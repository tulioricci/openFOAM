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

width = 0.01

ratio = 2
slope = 0.05
curve = 0.05
loglevel = 0

gas = ct.Solution("uiuc_7sp_phenolics.yaml")

#transp_model = 'mixture-averaged'
transp_model = 'unity-Lewis-number'
gas.transport_model = transp_model
nspecies = gas.n_species

air = "O2:0.21,N2:0.79"
fuel = "C2H4:1"

# slpm is defined at 273.15K
gas.TP = 273.15, 101325.0
gas.set_equivalence_ratio(phi=phi, fuel=fuel, oxidizer=air)
y_unburned = gas.Y
rho_ref = gas.density

u_ref = flow_rate*lmin_to_m3s/A_int
rhoU_ref = rho_ref*u_ref

# using 300K as the inlet temperature
gas.TP = 300.0, 101325.0
gas.set_equivalence_ratio(phi=phi, fuel=fuel, oxidizer=air)
y_unburned = gas.Y
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

# Pull temperature, density, mass fractions, and pressure from Cantera
# set the mass flow rate at the inlet
sim = ct.ImpingingJet(gas=gas, width=width)
sim.set_initial_guess(products='equil')

sim.inlet.mdot = rhoU_ref
sim.set_refine_criteria(ratio=4, slope=0.25, curve=0.25, prune=0.1)
sim.solve(loglevel, refine_grid=True, auto=True)

sim.set_refine_criteria(ratio=3, slope=0.15, curve=0.15, prune=0.05)
sim.solve(loglevel, refine_grid=True, auto=True)

sim.set_refine_criteria(ratio=ratio, slope=slope, curve=curve, prune=0.025)
sim.solve(loglevel, refine_grid=True, auto=True)


# ~~~ Reactants
rho_unburned = sim.density[0]
y_unburned = sim.Y[:,0]

# ~~~ Products
index_burned = np.argmax(sim.T) 
temp_burned = sim.T[index_burned]
rho_burned = sim.density[index_burned]
y_burned = sim.Y[:,index_burned]

y_shroud = y_burned*0.0
y_shroud[gas.species_index("N2")] = 1.0

x = y_shroud*0.0
x[gas.species_index("O2")] = 0.21
x[gas.species_index("N2")] = 0.79
gas.TPX = 300.0, 101325.0, x

y_atmosphere = np.zeros(nspecies)
dummy, rho_atmosphere, y_atmosphere = gas.TDY
temp_atmosphere, rho_atmosphere, y_atmosphere = gas.TDY

y_shroud = y_atmosphere*0.0
y_shroud[gas.species_index("N2")] = 1.0

print('m =', sim.velocity[0]*A_int/lmin_to_m3s,', phi =',phi, ', Tb =', sim.T[0], sim.T[-1], sim.velocity[0])

print(sum(y_shroud))
print(sum(y_atmosphere))
print(sum(y_burned))

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
    os.system("echo '    shield' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            fixedValue;' >> " + spc)
    os.system("echo '        value           uniform " + str(y_shroud[idx]).strip("'") + ";' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    burner' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            zeroGradient;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    wall' >> " + spc)
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
    
