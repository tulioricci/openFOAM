import pandas as pd
import numpy as np

import time

import cantera as ct

print(f"Runnning Cantera version: {ct.__version__}")

#%matplotlib inline
#%config InlineBackend.figure_formats = ["svg"]
import matplotlib.pyplot as plt

plt.rcParams["axes.labelsize"] = 18
plt.rcParams["xtick.labelsize"] = 12
plt.rcParams["ytick.labelsize"] = 12
plt.rcParams["figure.autolayout"] = True
plt.rcParams["figure.dpi"] = 120

#plt.style.use("ggplot")
#plt.style.use("seaborn-pastel")

gas = ct.Solution("uiuc_20sp.yaml")

# Define the reactor temperature and pressure
reactor_temperature = 1200  # Kelvin
reactor_pressure = 101325  # Pascals

gas.TP = reactor_temperature, reactor_pressure

# Define the fuel, oxidizer and set the stoichiometry
gas.set_equivalence_ratio(phi=1.0, fuel="C2H4:1", oxidizer={"O2": 1.0, "N2": 3.76})
print(gas.Y[gas.species_index("C2H4")])
print(gas.Y[gas.species_index("O2")])
print(gas.Y[gas.species_index("N2")])

#import sys
#sys.exit()

# Create a batch reactor object and add it to a reactor network
# In this example, the batch reactor will be the only reactor
# in the network
r = ct.IdealGasReactor(contents=gas, name="Batch Reactor")
reactor_network = ct.ReactorNet([r])

# use the above list to create a DataFrame
time_history = ct.SolutionArray(gas, extra="t")
transport = []

def ignition_delay(states, species):
    """
    This function computes the ignition delay from the occurence of the
    peak in species' concentration.
    """
    i_ign = states(species).Y.argmax()
    return states.t[i_ign]

reference_species = "C2H4"

# Tic
t0 = time.time()

# This is a starting estimate. If you do not get an ignition within this time, increase it
estimated_ignition_delay_time = 0.1
t = 0

counter = 1
while t < estimated_ignition_delay_time:
    t = reactor_network.step()
    if not counter % 10:
        # We will save only every 10th value. Otherwise, this takes too long
        # Note that the species concentrations are mass fractions
        time_history.append(r.thermo.state, t=t)
        transport.append(gas.mix_diff_coeffs)
    counter += 1

transport = np.asarray(transport)
plt.plot(time_history.T, transport[:,0]); plt.show()

import sys
sys.exit()

plt.figure()
plt.plot(time_history.t*1000, time_history.T, "-o", color='black', label='Cantera')
plt.xlabel("Time (ms)")
plt.ylabel("$Temperature$")

data = np.genfromtxt('../postProcessing/myProbes/0.000000/T',skip_header=4)
ndata = data.shape[0]
time = data[:,0]
plt.plot(time*1000,data[:,1],color="red")

plt.legend()
plt.xlim([0.0, 130e-2])
plt.ylim([900.0, 3100.0])
plt.savefig('Temp_x_time.png',dpi=200)
plt.show()



plt.figure()
plt.plot(time_history.t*1000, time_history.C2H4, "-o", color='black', label='Cantera')
plt.xlabel("Time (ms)")
plt.ylabel("$Temperature$")

data = np.genfromtxt('../postProcessing/myProbes/0.000000/C2H4',skip_header=4)
ndata = data.shape[0]
time = data[:,0]
plt.plot(time*1000,data[:,1],color="red")

plt.legend()
plt.xlim([0.0, 130e-2])
#plt.ylim([900.0, 3100.0])
plt.savefig('C2H4_x_time.png',dpi=200)
plt.show()
