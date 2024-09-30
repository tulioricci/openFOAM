import numpy as np
import cantera

mech_input = "uiuc_20sp.yaml"

equiv_ratio = 1.0
total_flow_rate = 25.0
width = 0.01

cantera_soln = cantera.Solution(mech_input)
nspecies = cantera_soln.n_species

width_mm = str('%02i' % (width*1000)) + "mm"

# Initial temperature, pressure, and mixture mole fractions are needed to
# set up the initial state in Cantera.

air = "O2:0.21,N2:0.79"
fuel = "C2H4:1"
cantera_soln.set_equivalence_ratio(phi=equiv_ratio,
                                   fuel=fuel, oxidizer=air)
temp_unburned = 300.0
pres_unburned = 101325.0
cantera_soln.TP = temp_unburned, pres_unburned
x_reference = cantera_soln.X
y_reference = cantera_soln.Y
rho_int = cantera_soln.density

r_int = 2.38*25.4/2000.0
r_ext = 2.89*25.4/2000.0

try:
    total_flow_rate
except NameError:
    total_flow_rate = None

if total_flow_rate is not None:
    flow_rate = total_flow_rate*1.0
else:
    idx_fuel = cantera_soln.species_index("C2H4")
    flow_rate = air_flow_rate/(sum(x_reference) - x_reference[idx_fuel])

A_int = np.pi*r_int**2  # noqa
lmin_to_m3s = 1.66667e-5
u_int = flow_rate*lmin_to_m3s/A_int
rhoU_int = rho_int*u_int  # noqa

#mass_shroud = shroud_rate*1.0
A_ext = np.pi*(r_ext**2 - r_int**2)  # noqa
u_ext = u_int #mass_shroud*lmin_to_m3s/A_ext
rho_ext = 101325.0/((cantera.gas_constant/cantera_soln.molecular_weights[-1])*300.)
# mdot_ext = rho_ext*u_ext*A_ext
rhoU_ext = rho_ext*u_ext  # noqa

print("width=", width_mm, "(mm)")
print("V_dot=", flow_rate, "(L/min)")
print(f"{A_int= }", "(m^2)")
print(f"{A_ext= }", "(m^2)")
print(f"{u_int= }", "(m/s)")
print(f"{u_ext= }", "(m/s)")
print(f"{rho_int= }", "(kg/m^3)")
print(f"{rho_ext= }", "(kg/m^3)")
print(f"{rhoU_int= }")
print(f"{rhoU_ext= }")
print("ratio=", u_ext/u_int,"\n")

# Set Cantera internal gas temperature, pressure, and mole fractios
cantera_soln.TPX = temp_unburned, pres_unburned, x_reference


# Pull temperature, density, mass fractions, and pressure from Cantera
# set the mass flow rate at the inlet
sim = cantera.ImpingingJet(gas=cantera_soln, width=width)
sim.inlet.mdot = rhoU_int
sim.set_refine_criteria(ratio=2, slope=0.1, curve=0.1, prune=0.0)
sim.set_initial_guess(products='equil')
sim.solve(loglevel=0, refine_grid=True, auto=True)

# ~~~ Reactants
assert np.absolute(sim.density[0]*sim.velocity[0] - rhoU_int) < 1e-11
rho_unburned = sim.density[0]
y_unburned = sim.Y[:,0]

# ~~~ Products
index_burned = np.argmax(sim.T) 
temp_burned = sim.T[index_burned]
rho_burned = sim.density[index_burned]
y_burned = sim.Y[:,index_burned]

y_shroud = y_burned*0.0
y_shroud[cantera_soln.species_index("N2")] = 1.0

x = y_shroud*0.0
x[cantera_soln.species_index("O2")] = 0.21
x[cantera_soln.species_index("N2")] = 0.79
cantera_soln.TPX = 300.0, 101325.0, x

y_atmosphere = np.zeros(nspecies)
dummy, rho_atmosphere, y_atmosphere = cantera_soln.TDY
temp_atmosphere, rho_atmosphere, y_atmosphere = cantera_soln.TDY

print(sum(y_shroud))
print(sum(y_atmosphere))
print(sum(y_burned))

import os
for spc in cantera_soln.species_names:
    idx = cantera_soln.species_index(spc)
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
    os.system("echo '    flow_to_porousMat' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            zeroGradient;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    flow_to_graphite' >> " + spc)
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
    
