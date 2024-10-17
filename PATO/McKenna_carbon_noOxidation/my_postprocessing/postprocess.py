import numpy as np

import os.path

def read_openfoam_files(filename, verbose=0):

    line_number = 0
    myData = []
    flag = False

    if os.path.exists(filename) is False:
        return np.array([])

    with open(filename, 'r') as file:
        for line in file:
            aux = line.strip()
            line_number += 1
            if flag is False:
                try:
                    nelements = int(aux)
                    if verbose > 0: print(nelements)
                    flag = True
                except:
                    continue

            if flag:
                if aux == "(":
                    continue
                elif aux == ")":
                    break
                else:
                    try:
                        data = float(aux)
                        myData.append(data)
                    except:
                        break

    return np.array(myData)[1:]

volume = read_openfoam_files("V")

import glob
simulationFolders = []
simulationFolders = sorted(glob.glob('../[0-9].*'))
simulationFolders += sorted(glob.glob('../[0-9][0-9].*'))
simulationFolders += sorted(glob.glob('../[0-9][0-9][0-9].*'))

nFolders = len(simulationFolders)

ii = 0
mass = np.zeros((nFolders))
time = np.zeros((nFolders))
for timeFolder in simulationFolders:
    data = read_openfoam_files(timeFolder + "/porousMat/rho_s[2]")
    currentTime = timeFolder.replace("../","")
    time[ii] = float(currentTime)
    if data.shape[0] == 0:
        mass[ii] = sum(1200*volume)
    else:
        mass[ii] = sum(data*volume)
    ii += 1
    




import matplotlib.pyplot as plt
from matplotlib.ticker import *

#plt.rc('text', usetex=True)
#plt.rcParams['text.latex.preamble']=[r"\usepackage{amsmath}"]
#plt.rcParams['text.latex.preamble']=[r'\boldmath']
plt.rc('text', usetex=True)
plt.rcParams['text.latex.preamble']=r"\usepackage{amsmath}"

plt.rcParams["axes.labelsize"] = 16
plt.rcParams["xtick.labelsize"] = 14
plt.rcParams["ytick.labelsize"] = 14
plt.rcParams["figure.dpi"] = 200
plt.rcParams["legend.fontsize"] = 15

fig = plt.figure(1,figsize=[6.4,5.2])
ax1 = fig.add_subplot(111)
ax2 = plt.twiny()
ax3 = plt.twinx()
ax1.set_position([0.15,0.12,0.8,0.84])
ax2.set_position([0.15,0.12,0.8,0.84])
ax3.set_position([0.15,0.12,0.8,0.84])
ax1.tick_params(axis='both', labelsize=16, bottom=True, top=False, left=True, right=False)
ax2.tick_params(labelbottom=False, labeltop=False, labelleft=False, labelright=False) 
ax3.tick_params(labelbottom=False, labeltop=False, labelleft=False, labelright=False) 
ax1.xaxis.set_minor_locator(AutoMinorLocator()) 
ax2.xaxis.set_minor_locator(AutoMinorLocator())
ax1.yaxis.set_minor_locator(AutoMinorLocator()) 
ax3.yaxis.set_minor_locator(AutoMinorLocator())

ax1.tick_params(axis='both', bottom=True, top=True, left=True, right=True,
                labelbottom=True, labeltop=False, labelleft=True,
                labelright=False)

# mass * volume fraction * 1000 kg to g * epsilon
ax1.plot(time, mass*90*1000*0.1)

ax1.set_xlim(0., 50.)
ax3.set_xlim(0., 50.)
ax1.set_ylim(0.9, 1.15)
ax2.set_ylim(0.9, 1.15)

ax1.set_xlabel(r'$\bf{Time} \; (s)$')
ax1.set_ylabel(r'$\bf{Mass} \; (g)$')

plt.show()
