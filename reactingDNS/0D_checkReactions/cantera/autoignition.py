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


gas.set_equivalence_ratio(phi=1.0, fuel="C2H4:1", oxidizer={"O2": 1.0, "N2": 3.76})
#y = np.zeros(gas.n_species,)
#y[gas.species_index("C2H4")] = 0.34
#y[gas.species_index("O2")] = 0.33
#y[gas.species_index("N2")] = 0.33
#gas.Y = y
x0 = gas.X

#print(x0)
#import sys
#sys.exit()

N = 89
cantera = np.zeros((N,4))
for ii, temperature in enumerate(np.linspace(300,2500,N)):
    pressure = 101325.0*temperature/300.0
    gas.TPX = temperature, pressure, x0
    T, P = gas.TP

    print(T, P, gas.heat_release_rate)
    cantera[ii,0] = T
    cantera[ii,1] = gas.heat_release_rate
    cantera[ii,2] = gas.net_production_rates[gas.species_index("C2H4")]
    cantera[ii,3] = gas.net_production_rates[gas.species_index("O2")]

#import sys
#sys.exit()
    
plt.close("all")
plt.figure()
plt.plot(cantera[:,0], np.abs(cantera[:,1]), "-o", color='black', label='Cantera')

data = np.genfromtxt('../postProcessing/myProbes/0.0000000/chemistryhsSource',skip_header=3)
data_T = np.genfromtxt('../postProcessing/myProbes/0.0000000/T',skip_header=3)
T = data_T[:,1]
plt.plot(T[:-1],np.abs(data[1:,1]),color="red",marker="x")
plt.yscale("log")
#plt.legend()
#plt.xlim([300.0, 2500])
plt.xlabel("$Temperature$")
#plt.ylim([900.0, 3100.0])
#plt.ylabel("Time (ms)")
plt.savefig('qDot_x_T.png',dpi=200)
plt.show()    

plt.close("all")
plt.figure()
plt.plot(cantera[:,0], np.abs(cantera[:,2]), "-o", color='black', label='Cantera')
data = np.genfromtxt('../postProcessing/myProbes/0.0000000/omegaDotC2H4',skip_header=3)
data_T = np.genfromtxt('../postProcessing/myProbes/0.0000000/T',skip_header=3)
T = data_T[:,1]
plt.plot(T[:-1],np.abs(data[1:,1])/0.0637292540464,color="red",marker="x")

#plt.plot(cantera[:,0], np.abs(cantera[:,3]), "-o", color='gray', label='Cantera')
#data = np.genfromtxt('../postProcessing/myProbes/0.0000000/omegaDotO2',skip_header=3)
#data_T = np.genfromtxt('../postProcessing/myProbes/0.0000000/T',skip_header=3)
#T = data_T[:,1]
#plt.plot(T[:-1],np.abs(data[1:,1]),color="green",marker="x")
plt.yscale("log")
#plt.legend()
#plt.xlim([300.0, 2500])
plt.xlabel("$Temperature$")
#plt.ylim([900.0, 3100.0])
#plt.ylabel("Time (ms)")
plt.savefig('omegaDotC2H4_x_T.png',dpi=200)
plt.show()    






array = np.zeros((23,3+gas.n_species))
sutherland = np.zeros(23,)
polyval = np.zeros(23,)
cantera = np.zeros(23,)

for ii, temperature in enumerate(np.linspace(300,2500,23)):
    pressure = 101325.0*temperature/300.0
    gas.TPX = temperature, pressure, x0
    T = temperature

    tmpT = np.log(temperature)
    array[ii,0] = temperature
    array[ii,1] = gas.viscosity
    array[ii,2] = gas.thermal_conductivity/gas.cp
    for j in range(gas.n_species):
        array[ii,3+j] = gas.mix_diff_coeffs[j]
        
plt.figure()
plt.plot(array[:,0], array[:,1], "-o", color='black', label='Cantera')

data = np.genfromtxt('../postProcessing/myProbes/0.0000000/mixMu',skip_header=3)
data_T = np.genfromtxt('../postProcessing/myProbes/0.0000000/T',skip_header=3)
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

data = np.genfromtxt('../postProcessing/myProbes/0.0000000/mixAlpha',skip_header=3)
data_T = np.genfromtxt('../postProcessing/myProbes/0.0000000/T',skip_header=3)
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
plt.plot(array[:,0], array[:,3+gas.species_index("N2")], "-o", color='gray', label='Cantera')

data_T = np.genfromtxt('../postProcessing/myProbes/0.0000000/T',skip_header=3)
T = data_T[:-1,1]
data_P = np.genfromtxt('../postProcessing/myProbes/0.0000000/p',skip_header=3)
p = data_P[:-1,1]
data = np.genfromtxt('../postProcessing/myProbes/0.0000000/DiffC2H4',skip_header=3)
plt.plot(T,data[1:,1],color="red")
data = np.genfromtxt('../postProcessing/myProbes/0.0000000/DiffN2',skip_header=3)
plt.plot(T,data[1:,1], color="green")

#plt.legend()
plt.xlim([300.0, 2500])
plt.xlabel("$Temperature$")
#plt.ylim([900.0, 3100.0])
#plt.ylabel("Time (ms)")
plt.savefig('diffC2H4_x_T.png',dpi=200)
plt.show()
