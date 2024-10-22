import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

plt.rcParams["axes.labelsize"] = 18
plt.rcParams["xtick.labelsize"] = 12
plt.rcParams["ytick.labelsize"] = 12
plt.rcParams["figure.autolayout"] = True
plt.rcParams["figure.dpi"] = 120

#plt.style.use("ggplot")
#plt.style.use("seaborn-pastel")

import cantera as ct
print(f"Running Cantera version: {ct.__version__}")
gas = ct.Solution("uiuc_20sp.yaml")
nspecies = gas.n_species

from random import randint
colors = []
for i in range(nspecies):
    colors.append('#%06X' % randint(0, 0xFFFFFF))

for species_index in np.arange(0,nspecies):
    kappa = []
    mu = []
    temp = []
    for T in np.arange(300.,3020.,20.):
        Y = np.zeros(nspecies,)
        Y[species_index] = 1.0
        gas.TPY = T, ct.one_atm, Y

        temp.append(T)
        kappa.append(gas.thermal_conductivity)
        mu.append(gas.viscosity)

    print(gas.species_name(species_index))

    mu = np.array(mu)
    kappa = np.array(kappa)
    temp = np.array(temp)
    plt.plot(temp, kappa, label=gas.species_name(species_index),color=colors[species_index])

    tt = np.arange(300,3020,20.)

    coeffs = np.polyfit(temp, mu, deg=3)
    print("muCoeffs<8>     (", coeffs[3], coeffs[2], coeffs[1], coeffs[0], "0 0 0 0);  // viscosity(T)")

    coeffs = np.polyfit(temp, kappa, deg=3)
    plt.plot(tt,np.polyval(coeffs, tt)," ",marker="o",color=colors[species_index],markerfacecolor="none")

    print("kappaCoeffs<8>  (", coeffs[3], coeffs[2], coeffs[1], coeffs[0], "0 0 0 0);  // conductivity(T)")

plt.legend()
plt.show()

for species_index in np.arange(0,nspecies):
    mu = []
    temp = []
    for T in np.arange(300.,3020.,20.):
        Y = np.zeros(nspecies,)
        Y[species_index] = 1.0
        gas.TPY = T, ct.one_atm, Y

        temp.append(T)
        mu.append(gas.viscosity)

    mu = np.array(mu)
    temp = np.array(temp)
    plt.plot(temp, mu, label=gas.species_name(species_index),color=colors[species_index])

    coeffs = np.polyfit(temp, mu, deg=3)
    tt = np.arange(300.,3020.,20.)
    plt.plot(tt,np.polyval(coeffs, tt)," ",marker="o",color=colors[species_index],markerfacecolor="none")


plt.legend()
plt.show()
        



