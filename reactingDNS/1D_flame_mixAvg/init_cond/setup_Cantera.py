import numpy as np
import cantera

import sys
import getopt

import os

data = np.genfromtxt("flame1D_uiuc_20sp_phi1.00_mix.csv", skip_header=1, delimiter=',')

filename = "flame1D_uiuc_20sp_phi1.00_mix.csv"
f = open(filename)
header = f.readline()
header = header.replace('"', '')
header = header.strip()
header = header.replace(' ', '')
header = header.replace('Y_', '')
header = header.split(',')
f.close()

species_names = header[4:-1] 

os.system("echo '' > " + "setFieldsDict_aux")
for i, spc in enumerate(species_names):
    
    ii = i + 4    
    y_unburned = np.maximum(data[0,ii], 0.0)
    y_burned = data[-1,ii]
    
    os.system("head -n 19 Ydefault >" + spc)
    os.system("sed -i '14s/.*/    object      " + spc + ";/' " + spc)

    #os.system("echo 'internalField   uniform " + str(y_unburned) + ";' >> " + spc)
    os.system("echo 'internalField  #codeStream' >> " + spc)
    os.system("echo '{' >> " + spc)
    os.system("echo '  codeInclude  /* Headers for compilation */' >> " + spc)
    os.system("echo '  #{' >> " + spc)
    os.system("echo '  #include \"fvCFD.H\"' >> " + spc)
    os.system("echo '  #};' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '  codeOptions /* Compilation options */' >> " + spc)
    os.system("echo '  #{' >> " + spc)
    os.system("echo '    -I$(FOAM_SRC)/finiteVolume/lnInclude \\' >> " + spc)
    os.system("echo '    -I$(FOAM_SRC)/meshTools/lnInclude ' >> " + spc)
    os.system("echo '  #};' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '  codeLibs  /* Libraries for compilation */' >> " + spc)
    os.system("echo '  #{' >> " + spc)
    os.system("echo '    -lmeshTools \\' >> " + spc)
    os.system("echo '    -lfiniteVolume' >> " + spc)
    os.system("echo '  #};' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '  code  /* User code */' >> " + spc)
    os.system("echo '  #{' >> " + spc)
    os.system("echo '    /* Access to internal mesh information */' >> " + spc)
    os.system("echo '    const IOdictionary& d = static_cast<const IOdictionary&>(dict);' >> " + spc)
    os.system("echo '    const fvMesh& mesh = refCast<const fvMesh>(d.db());' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '    scalar T1 = " + str(y_unburned) + ";  // Value at x1' >> " + spc)
    os.system("echo '    scalar T2 = " + str(y_burned) + ";  // Value at x2' >> " + spc)
    os.system("echo '    scalar x1 = -0.0002;  // Start of the domain' >> " + spc)
    os.system("echo '    scalar x2 = 0.0002;  // End of the domain' >> " + spc)
    os.system("echo '    scalar gradient = (T2 - T1) / (x2 - x1);' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '    scalarField T(mesh.nCells(), 0.); /* initialization */' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '    forAll(T, i) /* Loop on elements */' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '      const scalar x = mesh.C()[i].x(); /* Access to z component of cell centers coordinates */' >> " + spc)
    os.system("echo '      if (x < x1){' >> " + spc)
    os.system("echo '        T[i] = T1;' >> " + spc)
    os.system("echo '      }' >> " + spc)
    os.system("echo '      else if (x > x2){' >> " + spc)
    os.system("echo '        T[i] = T2;' >> " + spc)
    os.system("echo '      }' >> " + spc)
    os.system("echo '      else{' >> " + spc)
    os.system("echo '       T[i] = T1 + gradient * (x - x1); // Compute the temperature' >> " + spc)
    os.system("echo '        //Info << x << tab << T[i] << endl;' >> " + spc)
    os.system("echo '      }' >> " + spc)
    os.system("echo '    }' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '    writeEntry(os, \"\", T); /* Write output in the dictionary */' >> " + spc)
    os.system("echo '' >> " + spc)
    os.system("echo '  #};' >> " + spc)
    os.system("echo '};   ' >> " + spc) 
  
    os.system("echo '' >> " + spc)   
    os.system("echo 'boundaryField' >> " + spc)
    os.system("echo '{' >> " + spc)
    os.system("echo '    inlet' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            fixedValue;' >> " + spc)
    os.system("echo '        value           uniform " + str(y_unburned) + ";' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    outlet' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            zeroGradient;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '' >> " + spc)
    os.system("echo '    frontAndBack' >> " + spc)
    os.system("echo '    {' >> " + spc)
    os.system("echo '        type            empty;' >> " + spc)
    os.system("echo '    }' >> " + spc)

    os.system("echo '}' >> " + spc)
    
    os.system("echo 'volScalarFieldValue '" + spc + " " +  str(y_burned) + " >>  setFieldsDict_aux")
    
    
os.system("echo 'volVectorFieldValue U (" +  str(data[-1,1]) + " 0.0 0.0)' >>  setFieldsDict_aux")
os.system("echo 'volScalarFieldValue T " +  str(data[-1,2]) + "' >>  setFieldsDict_aux")
