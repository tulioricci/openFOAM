import numpy as np
import cantera as ct
import os
import sys
import getopt

arg_list = sys.argv[1:]

phi = None
opts, args = getopt.getopt(arg_list,":",["phi=","slpm="])
for opt, arg in opts:
    if opt in ("--phi"):
        phi = float(arg)
        print ('Equivalence ratio = ', float(phi))
        
    if opt in ("--slpm"):
        flow_rate = float(arg)
        print ('Volumetric flow rate = ', float(flow_rate))        

if phi is None:
    print("Define the equivalence ratio with --phi")
    sys.exit()

if flow_rate is None:
    print("Define the flow rate with --slpm")
    sys.exit()

r_int = 2.38*25.4/2000 #radius, actually
A_int = np.pi*r_int**2
lmin_to_m3s = 1.66667e-5

use_radiation = True
transp_model = 'unity-Lewis-number'
enable_soret = False
gas = ct.Solution("uiuc_20sp.yaml")
gas.transport_model = transp_model

# slpm is defined at 273.15K
x = np.zeros(gas.n_species,)
x[gas.species_index('N2')] = 1.0
gas.TPX = 273.15, 101325.0, x
rho_ref = gas.density

u_ref = flow_rate*lmin_to_m3s/A_int
rhoU_ref = rho_ref*u_ref

# using 300K as the inlet temperature
air = "O2:0.21,N2:0.79"
fuel = "C2H4:1"
gas.TP = 300.0, 101325.0
gas.set_equivalence_ratio(phi=phi, fuel=fuel, oxidizer=air)
rho_eff = gas.density

u_eff = rhoU_ref/rho_eff

os.system("head -n 20 U > dummy")
os.system("mv dummy U")
os.system("echo '' >> U")
os.system("echo 'boundaryField' >> U")
os.system("echo '{' >> U")
os.system("echo '    f_front' >> U")
os.system("echo '    {' >> U")
os.system("echo '        type            wedge;' >> U")
os.system("echo '    }' >> U")
os.system("echo '    outlet' >> U")
os.system("echo '    {' >> U")
os.system("echo '        type            inletOutlet;' >> U")
os.system("echo '        inletValue      uniform ( 0 0 0 );' >> U")
os.system("echo '    }' >> U")
os.system("echo '    farfield' >> U")
os.system("echo '    {' >> U")
os.system("echo '        type            inletOutlet;' >> U")
os.system("echo '        inletValue      uniform ( 0 0 0 );' >> U")
os.system("echo '    }' >> U")
os.system("echo '    f_back' >> U")
os.system("echo '    {' >> U")
os.system("echo '        type            wedge;' >> U")
os.system("echo '    }' >> U")
os.system("echo '    fuel' >> U")
os.system("echo '    {' >> U")
os.system("echo '        type            fixedValue;' >> U")
os.system("echo '        value           uniform (0 " + str(u_eff) + " 0);' >> U")
os.system("echo '    }' >> U")
os.system("echo '    flow_to_porousMat' >> U")
os.system("echo '    {' >> U")
os.system("echo '        type            fixedValueToNbrValue;' >> U")
os.system("echo '        nbr             U;' >> U")
os.system("echo '        value	        uniform ( 0 0 0 );' >> U")
os.system("echo '    }' >> U")
os.system("echo '    flow_to_graphite' >> U")
os.system("echo '    {' >> U")
os.system("echo '        type            noSlip;' >> U")
os.system("echo '    }' >> U")
os.system("echo '    burner' >> U")
os.system("echo '    {' >> U")
os.system("echo '        type            noSlip;' >> U")
os.system("echo '    }' >> U")
os.system("echo '    shield' >> U")
os.system("echo '    {' >> U")
os.system("echo '        type            fixedValue;' >> U")
os.system("echo '        value           uniform (0 " + str(u_eff) + " 0);' >> U")
os.system("echo '    }' >> U")
os.system("echo '}' >> U")

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

width = 0.01
sim = ct.ImpingingJet(gas=gas, width=width)
sim.inlet.mdot = rhoU_ref
#sim.set_refine_criteria(ratio=2, slope=0.05, curve=0.05, prune=0.0)
sim.set_initial_guess(products='equil')
sim.soret_enabled = enable_soret
sim.radiation_enabled = use_radiation
#sim.solve(loglevel=0, refine_grid=True, auto=True)

loglevel = 0
ratio = 2
slope= 0.05
curve = 0.05
print(rhoU_ref)
sim.set_refine_criteria(ratio=4, slope=0.25, curve=0.25,
                        prune=0.1)
sim.solve(loglevel, refine_grid=True, auto=True)
os.system("date")

sim.set_refine_criteria(ratio=3, slope=0.15, curve=0.15,
                        prune=0.05)
sim.solve(loglevel, refine_grid=True, auto=True)
os.system("date")

sim.set_refine_criteria(ratio=ratio, slope=slope, curve=curve,
                        prune=0.025)
sim.solve(loglevel, refine_grid=True, auto=True)
os.system("date")

sim.set_refine_criteria(ratio=ratio, slope=slope, curve=curve,
                        prune=0.025)
sim.solve(loglevel, refine_grid=True, auto=True)
os.system("date")


#sim.save("debug.csv", basis="mass", overwrite=True)

y_unburned = sim.Y[:,0]

x_atmosphere = np.zeros(gas.n_species,)
x_atmosphere[gas.species_index("O2")] = 0.21
x_atmosphere[gas.species_index("N2")] = 0.79

gas.X = x_atmosphere
y_atmosphere = gas.Y

y_shroud = y_atmosphere*0.0
y_shroud[gas.species_index("N2")] = 1.0

import os
for spc in gas.species_names:
    idx = gas.species_index(spc)

    print(spc, idx)
    os.system("head -n 19 Ydefault >" + spc)
    os.system("sed -i '14s/.*/    object      " + spc + ";/' " + spc)

    os.system("echo 'internalField   uniform " + str(y_atmosphere[idx]).strip("'") + ";' >> " + spc)
    
    os.system("echo '' >> " + spc)
    os.system("echo 'boundaryField' >> " + spc)
    os.system("echo '{' >> " + spc)

    os.system("echo '    fuel' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            fixedValue;' >> " + spc)
    os.system("echo '        value           uniform " + str(y_unburned[idx]).strip("'") + ";' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    shield' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            fixedValue;' >> " + spc)
    os.system("echo '        value           uniform " + str(y_shroud[idx]).strip("'") + ";' >> " + spc)
    os.system("echo '    }' >> " + spc)
    
    os.system("echo '    flow_to_porousMat' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            zeroGradient;' >> " + spc)
    os.system("echo '    }' >> " + spc)
    
    os.system("echo '    flow_to_graphite' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            zeroGradient;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    outlet' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            zeroGradient;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    farfield' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            zeroGradient;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    burner' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            zeroGradient;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    sample' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            zeroGradient;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    f_front' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            wedge;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    f_back' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            wedge;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '}' >> " + spc)
    
