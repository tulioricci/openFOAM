import numpy as np
import cantera as ct

import sys
import getopt

arg_list = sys.argv[1:]

phi = None
opts, args = getopt.getopt(arg_list,":",["phi="])
for opt, arg in opts:
    if opt in ("--phi"):
        phi = float(arg)
        print ('Equivalence ratio = ', float(phi))

if phi is None:
    print("Define the equivalence ratio with --phi")
    sys.exit()

gas = ct.Solution("uiuc_20sp.yaml")

air = "O2:0.21,N2:0.79"
fuel = "C2H4:1"
gas.TP = 300.0, 101325.0

gas.set_equivalence_ratio(phi=phi, fuel=fuel, oxidizer=air)
y_unburned = gas.Y

x_atmosphere = y_unburned*0.0
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
    os.system("echo '        value           uniform " + str(y_unburned[idx]) + ";' >> " + spc)
    os.system("echo '    }' >> " + spc)
    os.system("echo '' >> " + spc)
    
    os.system("echo '    shield' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            fixedValue;' >> " + spc)
    os.system("echo '        value           uniform " + str(y_shroud[idx]) + ";' >> " + spc)
    os.system("echo '    }' >> " + spc)
    os.system("echo '' >> " + spc)

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
    os.system("echo '    plate' >> " + spc)
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
    
