import pandas as pd
import numpy as np

import time

np.set_printoptions(edgeitems=10,linewidth=132,suppress=True)

import cantera as ct
print(f"Runnning Cantera version: {ct.__version__}")

import matplotlib.pyplot as plt

plt.rcParams["axes.labelsize"] = 18
plt.rcParams["xtick.labelsize"] = 12
plt.rcParams["ytick.labelsize"] = 12
plt.rcParams["figure.autolayout"] = True
plt.rcParams["figure.dpi"] = 120

gas = ct.Solution("uiuc_20sp.yaml")

array = np.zeros((23,3+gas.n_species))
sutherland = np.zeros(23,)
polyval = np.zeros(23,)
cantera = np.zeros(23,)

for i in range(1):
    
    x = np.zeros(gas.n_species,)
    x[gas.species_index("C2H4")] = 0.5
    x[gas.species_index("N2")] = 0.5
    #x = np.ones(gas.n_species,)/gas.n_species

    for ii, temperature in enumerate(np.linspace(300,2500,23)):
        gas.TPX = temperature, 101325.0*temperature/300.0, x
        T = temperature

        tmpT = np.log(temperature)
        array[ii,0] = temperature
        array[ii,1] = gas.viscosity
        array[ii,2] = gas.thermal_conductivity/gas.cp
        for j in range(gas.n_species):
            array[ii,3+j] = gas.mix_diff_coeffs[j]
        
plt.figure()
plt.plot(array[:,0], array[:,1], "-o", color='black', label='Cantera')

data = np.genfromtxt('../postProcessing/myProbes/0.000000/mixMu',skip_header=3)
data_T = np.genfromtxt('../postProcessing/myProbes/0.000000/T',skip_header=3)
T = data_T[:-1,1]
plt.plot(T,data[1:,1],color="red")

#plt.legend()
plt.xlim([300.0, 2500])
plt.xlabel("$Temperature$")
#plt.ylim([900.0, 3100.0])
#plt.ylabel("Time (ms)")
plt.savefig('mu_x_T.png',dpi=200)
plt.show()


plt.figure()
plt.plot(array[:,0], array[:,2], "-o", color='black', label='Cantera')

data = np.genfromtxt('../postProcessing/myProbes/0.000000/mixAlpha',skip_header=3)
data_T = np.genfromtxt('../postProcessing/myProbes/0.000000/T',skip_header=3)
T = data_T[:-1,1]
plt.plot(T,data[1:,1],color="red")

#plt.legend()
plt.xlim([300.0, 2500])
plt.xlabel("$Temperature$")
#plt.ylim([900.0, 3100.0])
#plt.ylabel("Time (ms)")
plt.savefig('alpha_x_T.png',dpi=200)
plt.show()


plt.close('all')
plt.figure()
plt.plot(array[:,0], array[:,3+gas.species_index("C2H4")], "-o", color='black', label='Cantera')
plt.plot(array[:,0], array[:,3+gas.species_index("N2")], "--", color='gray', label='Cantera')

data_T = np.genfromtxt('../postProcessing/myProbes/0.000000/T',skip_header=3)
T = data_T[:-1,1]
data_P = np.genfromtxt('../postProcessing/myProbes/0.000000/p',skip_header=3)
p = data_P[:-1,1]
data = np.genfromtxt('../postProcessing/myProbes/0.000000/DiffC2H4',skip_header=3)
plt.plot(T,data[1:,1],color="red")
data = np.genfromtxt('../postProcessing/myProbes/0.000000/DiffN2',skip_header=3)
plt.plot(T,data[1:,1],color="green")

#plt.legend()
plt.xlim([300.0, 2500])
plt.xlabel("$Temperature$")
#plt.ylim([900.0, 3100.0])
#plt.ylabel("Time (ms)")
plt.savefig('diffC2H4_x_T.png',dpi=200)
plt.show()


import sys
sys.exit()




for i, species in enumerate(gas.species_names):
    print(species + "\n{\n" +
    "Lambda1  " + str(gas.get_thermal_conductivity_polynomial(i)[0]) + ";\n" +
    "Lambda2  " + str(gas.get_thermal_conductivity_polynomial(i)[1]) + ";\n" +
    "Lambda3  " + str(gas.get_thermal_conductivity_polynomial(i)[2]) + ";\n" +
    "Lambda4  " + str(gas.get_thermal_conductivity_polynomial(i)[3]) + ";\n" +
    "Lambda5  " + str(gas.get_thermal_conductivity_polynomial(i)[4]) + ";\n" +
    "}" )

for i, species in enumerate(gas.species_names):
    for j in np.arange(0,i+1):
        print(gas.species_name(i) + "-" + gas.species_name(j) + "\n{\n" +
        "Diff1\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[0]) + ";\n" +
        "Diff2\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[1]) + ";\n" +
        "Diff3\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[2]) + ";\n" +
        "Diff4\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[3]) + ";\n" +
        "Diff5\t" + str(gas.get_binary_diff_coeffs_polynomial(i,j)[4]) + ";\n" +
        "}" )
