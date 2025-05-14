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

gas = ct.Solution("uiuc_7sp_phenolics.yaml")

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

x_atmosphere = y_unburned*0.0
x_atmosphere[gas.species_index("O2")] = 0.21
x_atmosphere[gas.species_index("N2")] = 0.79

gas.X = x_atmosphere
y_atmosphere = gas.Y

y_shroud = y_atmosphere*0.0
y_shroud[gas.species_index("N2")] = 1.0

import os
for spc in gas.species_names:
    if spc != "C":
        idx = gas.species_index(spc)

        print(spc, idx)
        os.system("head -n 19 Ydefault >" + spc)
        os.system("sed -i '14s/.*/    object      " + spc + ";/' " + spc)

        os.system("echo 'internalField   uniform " + str(y_atmosphere[idx]).strip("'") + ";' >> " + spc)
        
        os.system("echo '' >> " + spc)
        os.system("echo 'boundaryField' >> " + spc)
        os.system("echo '{' >> " + spc)

        os.system("echo '' >> " + spc)
        os.system("echo '    fuel' >> " + spc)
        os.system("echo '    {' >> " + spc)
        os.system("echo '        type            codedMixed;' >> " + spc)
        os.system("echo '        refValue        uniform " + str(y_unburned[idx]) + ";' >> " + spc)
        os.system("echo '        refGradient     uniform 0;' >> " + spc)
        os.system("echo '        valueFraction   uniform 1;' >> " + spc)
        os.system("echo '        name            my" + spc + "Inlet;' >> " + spc)
        os.system("echo '        redirectType    my" + spc + "inlet;' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '        code' >> " + spc)
        os.system("echo '        #{' >> " + spc)
        os.system("echo '            // Reference value at the boundary' >> " + spc)
        os.system("echo '            const scalar refVal = " + str(y_unburned[idx]) + ";' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '            const fvPatch& boundaryPatch = patch();        // Access the current boundary patch' >> " + spc)
        os.system("echo '            scalarField& refValueField = refValue();       // Access refValue (fixed value part)' >> " + spc)
        os.system("echo '            scalarField& refGradField = refGrad();         // Access refGradient (gradient part)' >> " + spc)
        os.system("echo '            scalarField& valueFracField = valueFraction(); // Control between Dirichlet (1.0) and Neumann (0.0)' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '            // TODO : get only the surface data somehow?' >> " + spc)
        os.system("echo '            const vectorField& faceNormals = boundaryPatch.Sf();' >> " + spc)
        os.system("echo '            const scalarField faceAreas = mag(faceNormals);' >> " + spc)
        os.system("echo '            const volVectorField& U = db().lookupObject<volVectorField>(\"U\"); // const' >> " + spc)
        os.system("echo '            const volScalarField& psi = db().lookupObject<volScalarField>(\"thermo:psi\"); // const' >> " + spc)
        os.system("echo '            const volScalarField& p = db().lookupObject<volScalarField>(\"p\"); // const' >> " + spc)
        os.system("echo '            const volScalarField& mix_alpha = db().lookupObject<volScalarField>(\"mixAlpha\"); // const' >> " + spc)
        os.system("echo '            const volScalarField& Y = db().lookupObject<volScalarField>(\"" + spc + "\"); // const' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '            // Loop over the boundary faces and compute necessary values' >> " + spc)
        os.system("echo '            forAll(boundaryPatch, faceI)' >> " + spc)
        os.system("echo '            {' >> " + spc)
        os.system("echo '                scalar psiVal = psi.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '                scalar pVal = p.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '                vector UVal = U.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '                scalar diffVal = mix_alpha.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '                scalar YVal = Y.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '                vector nHat = faceNormals[faceI] / faceAreas[faceI];' >> " + spc)
        os.system("echo '                scalar U_normal = UVal & nHat;' >> " + spc)
        os.system("echo '                scalar rhoU = psiVal * pVal * U_normal;' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '                // Compute the reference gradient based on velocity, species diffusivity, and concentration' >> " + spc)
        os.system("echo '                scalar refGradVal = - rhoU * (refVal - YVal) / (diffVal);' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '                // Set the refValue and refGrad for the boundary patch' >> " + spc)
        os.system("echo '                refValueField[faceI] = refVal;' >> " + spc)
        os.system("echo '                refGradField[faceI] = refGradVal;' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '                // Set the valueFraction field to 0.0, which corresponds to Neumann' >> " + spc)
        os.system("echo '                valueFracField[faceI] = 0.0;' >> " + spc)
        os.system("echo '            }' >> " + spc)
        os.system("echo '        #};' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '        codeOptions' >> " + spc)
        os.system("echo '        #{' >> " + spc)
        os.system("echo '            -I$(LIB_SRC)/../applications/solvers/combustion/reactingDNS/transport' >> " + spc)
        os.system("echo '        #};' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '        codeInclude' >> " + spc)
        os.system("echo '        #{' >> " + spc)
        os.system("echo '            #include <cmath>' >> " + spc)
        os.system("echo '            #include <iostream>' >> " + spc)
        os.system("echo '        #};' >> " + spc)
        os.system("echo '    }' >> " + spc)
        
        os.system("echo '' >> " + spc)
        os.system("echo '    shield' >> " + spc)
        os.system("echo '    {' >> " + spc)
        os.system("echo '        type            codedMixed;' >> " + spc)
        os.system("echo '        refValue        uniform " + str(y_shroud[idx]) + ";' >> " + spc)
        os.system("echo '        refGradient     uniform 0;' >> " + spc)
        os.system("echo '        valueFraction   uniform 1;' >> " + spc)
        os.system("echo '        name            my" + spc + "Shield;' >> " + spc)
        os.system("echo '        redirectType    my" + spc + "shield;' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '        code' >> " + spc)
        os.system("echo '        #{' >> " + spc)
        os.system("echo '            // Reference value at the boundary' >> " + spc)
        os.system("echo '            const scalar refVal = " + str(y_shroud[idx]) + ";' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '            const fvPatch& boundaryPatch = patch();        // Access the current boundary patch' >> " + spc)
        os.system("echo '            scalarField& refValueField = refValue();       // Access refValue (fixed value part)' >> " + spc)
        os.system("echo '            scalarField& refGradField = refGrad();         // Access refGradient (gradient part)' >> " + spc)
        os.system("echo '            scalarField& valueFracField = valueFraction(); // Control between Dirichlet (1.0) and Neumann (0.0)' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '            // TODO : get only the surface data somehow?' >> " + spc)
        os.system("echo '            const vectorField& faceNormals = boundaryPatch.Sf();' >> " + spc)
        os.system("echo '            const scalarField faceAreas = mag(faceNormals);' >> " + spc)
        os.system("echo '            const volVectorField& U = db().lookupObject<volVectorField>(\"U\"); // const' >> " + spc)
        os.system("echo '            const volScalarField& psi = db().lookupObject<volScalarField>(\"thermo:psi\"); // const' >> " + spc)
        os.system("echo '            const volScalarField& p = db().lookupObject<volScalarField>(\"p\"); // const' >> " + spc)
        os.system("echo '            const volScalarField& mix_alpha = db().lookupObject<volScalarField>(\"mixAlpha\"); // const' >> " + spc)
        os.system("echo '            const volScalarField& Y = db().lookupObject<volScalarField>(\"" + spc + "\"); // const' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '            // Loop over the boundary faces and compute necessary values' >> " + spc)
        os.system("echo '            forAll(boundaryPatch, faceI)' >> " + spc)
        os.system("echo '            {' >> " + spc)
        os.system("echo '                scalar psiVal = psi.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '                scalar pVal = p.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '                vector UVal = U.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '                scalar diffVal = mix_alpha.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '                scalar YVal = Y.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '                vector nHat = faceNormals[faceI] / faceAreas[faceI];' >> " + spc)
        os.system("echo '                scalar U_normal = UVal & nHat;' >> " + spc)
        os.system("echo '                scalar rhoU = psiVal * pVal * U_normal;' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '                // Compute the reference gradient based on velocity, species diffusivity, and concentration' >> " + spc)
        os.system("echo '                scalar refGradVal = - rhoU * (refVal - YVal) / (diffVal);' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '                // Set the refValue and refGrad for the boundary patch' >> " + spc)
        os.system("echo '                refValueField[faceI] = refVal;' >> " + spc)
        os.system("echo '                refGradField[faceI] = refGradVal;' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '                // Set the valueFraction field to 0.0, which corresponds to Neumann' >> " + spc)
        os.system("echo '                valueFracField[faceI] = 0.0;' >> " + spc)
        os.system("echo '            }' >> " + spc)
        os.system("echo '        #};' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '        codeOptions' >> " + spc)
        os.system("echo '        #{' >> " + spc)
        os.system("echo '            -I$(LIB_SRC)/../applications/solvers/combustion/reactingDNS/transport' >> " + spc)
        os.system("echo '        #};' >> " + spc)
        os.system("echo '' >> " + spc)
        os.system("echo '        codeInclude' >> " + spc)
        os.system("echo '        #{' >> " + spc)
        os.system("echo '            #include <cmath>' >> " + spc)
        os.system("echo '            #include <iostream>' >> " + spc)
        os.system("echo '        #};' >> " + spc)
        os.system("echo '    }' >> " + spc)

        if spc == "N2":
            os.system("echo '    flow_to_porousMat' >> " + spc)
            os.system("echo '    {' >> " + spc)
            os.system("echo '        type            calculated;' >> " + spc)
            os.system("echo '        value           uniform " + str(y_atmosphere[idx]).strip("'") + ";' >> " + spc)
            os.system("echo '    }' >> " + spc)
        else:        
            os.system("echo '    flow_to_porousMat' >> " + spc)
            os.system("echo '    {' >> " + spc)
            os.system("echo '        type            compressible::turbulentTemperatureCoupledBaffleMixed;' >> " + spc)
            os.system("echo '        value           uniform " + str(y_atmosphere[idx]).strip("'") + ";' >> " + spc)
            os.system("echo '        Tnbr 	         " + spc + ";' >> " + spc)
            os.system("echo '        kappaMethod     lookup;' >> " + spc)
            os.system("echo '        kappa           \"diffY[" + spc + "]\";' >> " + spc)
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
    
