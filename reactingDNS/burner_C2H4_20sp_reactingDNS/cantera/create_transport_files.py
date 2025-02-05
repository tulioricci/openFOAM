import numpy as np
import cantera as ct
print(f"Running Cantera version: {ct.__version__}")

gas = ct.Solution("uiuc_20sp.yaml")
nspecies = gas.n_species

header = (
"/*--------------------------------*- C++ -*----------------------------------*\\\n" +
"| =========                 |                                                 |\n" + 
"| \\\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |\n" + 
"|  \\\\    /   O peration     | Version:  2.3.0                                 |\n" + 
"|   \\\\  /    A nd           | Web:      www.OpenFOAM.org                      |\n" + 
"|    \\\\/     M anipulation  |                                                 |\n" + 
"\\*---------------------------------------------------------------------------*/\n" + 
"FoamFile\n" + 
"{\n" + 
"    version     2.0;\n" + 
"    format      ascii;\n" + 
"    class       dictionary;\n" + 
"    location    \"constant\";\n" + 
"    object      %s;\n" + 
"}\n" + 
"\n"
)

s = header % ("speciesMu")
f = open("speciesMu","w+")
f.writelines(s)
for i, species in enumerate(gas.species_names):
    strMu = (species + "\n{\n" +
    "Mu1  " + str(gas.get_viscosity_polynomial(i)[0]) + ";\n" +
    "Mu2  " + str(gas.get_viscosity_polynomial(i)[1]) + ";\n" +
    "Mu3  " + str(gas.get_viscosity_polynomial(i)[2]) + ";\n" +
    "Mu4  " + str(gas.get_viscosity_polynomial(i)[3]) + ";\n" +
    "Mu5  " + str(gas.get_viscosity_polynomial(i)[4]) + ";\n" +
    "}\n" )
    f.writelines(strMu)
    

s = header % ("speciesLambda")
f = open("speciesLambda","w+")
f.writelines(s)
for i, species in enumerate(gas.species_names):
    strLambda = (species + "\n{\n" +
    "Lambda1  " + str(gas.get_thermal_conductivity_polynomial(i)[0]) + ";\n" +
    "Lambda2  " + str(gas.get_thermal_conductivity_polynomial(i)[1]) + ";\n" +
    "Lambda3  " + str(gas.get_thermal_conductivity_polynomial(i)[2]) + ";\n" +
    "Lambda4  " + str(gas.get_thermal_conductivity_polynomial(i)[3]) + ";\n" +
    "Lambda5  " + str(gas.get_thermal_conductivity_polynomial(i)[4]) + ";\n" +
    "}\n" )
    f.writelines(strLambda)


s = header % ("binaryDiff")
f = open("binaryDiff","w+")
f.writelines(s)
for i, species in enumerate(gas.species_names):
    for j in np.arange(0,i+1):
        strDiff = (gas.species_name(i) + "-" + gas.species_name(j) + "\n{\n" +
        "Diff1\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[0]) + ";\n" +
        "Diff2\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[1]) + ";\n" +
        "Diff3\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[2]) + ";\n" +
        "Diff4\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[3]) + ";\n" +
        "Diff5\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[4]) + ";\n" +
        "}\n" )
        f.writelines(strDiff)
f.close()    
