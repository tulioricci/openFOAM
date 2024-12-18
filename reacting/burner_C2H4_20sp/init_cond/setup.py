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
    os.system("echo '            const volVectorField& U = db().lookupObject<volVectorField>(\"U\");' >> " + spc)
    os.system("echo '            const volScalarField& rho = db().lookupObject<volScalarField>(\"thermo:rho\");' >> " + spc)
    os.system("echo '            const vectorField& faceNormals = boundaryPatch.Sf();' >> " + spc)
    os.system("echo '            const scalarField faceAreas = mag(faceNormals);' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '            const volScalarField& Cp = db().lookupObject<volScalarField>(\"Cp\");' >> " + spc)
    os.system("echo '            const volScalarField& k = db().lookupObject<volScalarField>(\"thermo:kappa\");' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '            const volScalarField& Y = db().lookupObject<volScalarField>(\"" + spc + "\");' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '            // Loop over the boundary faces and compute necessary values' >> " + spc)
    os.system("echo '            forAll(boundaryPatch, faceI)' >> " + spc)
    os.system("echo '            {' >> " + spc)
    os.system("echo '                scalar rhoVal = rho.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '                vector UVal = U.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                vector nHat = faceNormals[faceI] / faceAreas[faceI];' >> " + spc)
    os.system("echo '                scalar U_normal = UVal & nHat;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                scalar rhoU = rhoVal * U_normal;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                scalar _kappa = k.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '                scalar _Cp = Cp.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '                scalar alphaVal = _kappa / _Cp;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                scalar YVal = Y.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                // Compute the reference gradient based on velocity, species diffusivity, and concentration' >> " + spc)
    os.system("echo '                scalar refGradVal = - rhoU * (refVal - YVal) / alphaVal;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                // Set the refValue and refGrad for the boundary patch' >> " + spc)
    os.system("echo '                refValueField[faceI] = refVal;' >> " + spc)
    os.system("echo '                refGradField[faceI] = refGradVal;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                // Set the valueFraction field to 0.0, which corresponds to Neumann' >> " + spc)
    os.system("echo '                valueFracField[faceI] = 0.0;' >> " + spc)
    if spc == "C2H4":
        os.system("echo '' >> " + spc)
        os.system("echo '                // Info << \" \" << faceI << \" \" << refGradVal << \" \" << refVal << \" \" << YVal << \" \" << rhoU << \" \" << alphaVal << nl;' >> " + spc)
    os.system("echo '            }' >> " + spc)
    os.system("echo '        #};' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '        codeOptions' >> " + spc)
    os.system("echo '        #{' >> " + spc)
    os.system("echo '            -I$(LIB_SRC)/finiteVolume/lnInclude \\' >> " + spc)
    os.system("echo '            -I$(LIB_SRC)/meshTools/lnInclude' >> " + spc)
    os.system("echo '        #};' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '        codeInclude' >> " + spc)
    os.system("echo '        #{' >> " + spc)
    os.system("echo '            #include \"fvCFD.H\"' >> " + spc)
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
    os.system("echo '            const volVectorField& U = db().lookupObject<volVectorField>(\"U\");' >> " + spc)
    os.system("echo '            const volScalarField& rho = db().lookupObject<volScalarField>(\"thermo:rho\");' >> " + spc)
    os.system("echo '            const vectorField& faceNormals = boundaryPatch.Sf();' >> " + spc)
    os.system("echo '            const scalarField faceAreas = mag(faceNormals);' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '            const volScalarField& Cp = db().lookupObject<volScalarField>(\"Cp\");' >> " + spc)
    os.system("echo '            const volScalarField& k = db().lookupObject<volScalarField>(\"thermo:kappa\");' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '            const volScalarField& Y = db().lookupObject<volScalarField>(\"" + spc + "\");' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '            // Loop over the boundary faces and compute necessary values' >> " + spc)
    os.system("echo '            forAll(boundaryPatch, faceI)' >> " + spc)
    os.system("echo '            {' >> " + spc)
    os.system("echo '                scalar rhoVal = rho.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '                vector UVal = U.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                vector nHat = faceNormals[faceI] / faceAreas[faceI];' >> " + spc)
    os.system("echo '                scalar U_normal = UVal & nHat;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                scalar rhoU = rhoVal * U_normal;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                scalar _kappa = k.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '                scalar _Cp = Cp.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '                scalar alphaVal = _kappa / _Cp;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                scalar YVal = Y.boundaryField()[boundaryPatch.index()][faceI];' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                // Compute the reference gradient based on velocity, species diffusivity, and concentration' >> " + spc)
    os.system("echo '                scalar refGradVal = - rhoU * (refVal - YVal) / alphaVal;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                // Set the refValue and refGrad for the boundary patch' >> " + spc)
    os.system("echo '                refValueField[faceI] = refVal;' >> " + spc)
    os.system("echo '                refGradField[faceI] = refGradVal;' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '                // Set the valueFraction field to 0.0, which corresponds to Neumann' >> " + spc)
    os.system("echo '                valueFracField[faceI] = 0.0;' >> " + spc)
    if spc == "C2H4":
        os.system("echo '' >> " + spc)
        os.system("echo '                // Info << \" \" << faceI << \" \" << refGradVal << \" \" << refVal << \" \" << YVal << \" \" << rhoU << \" \" << alphaVal << nl;' >> " + spc)
    os.system("echo '            }' >> " + spc)
    os.system("echo '        #};' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '        codeOptions' >> " + spc)
    os.system("echo '        #{' >> " + spc)
    os.system("echo '            -I$(LIB_SRC)/finiteVolume/lnInclude \\' >> " + spc)
    os.system("echo '            -I$(LIB_SRC)/meshTools/lnInclude' >> " + spc)
    os.system("echo '        #};' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '        codeInclude' >> " + spc)
    os.system("echo '        #{' >> " + spc)
    os.system("echo '            #include \"fvCFD.H\"' >> " + spc)
    os.system("echo '            #include <cmath>' >> " + spc)
    os.system("echo '            #include <iostream>' >> " + spc)
    os.system("echo '        #};' >> " + spc)
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
    
