import numpy as np
import os
import argparse

np.set_printoptions(edgeitems=9,linewidth=256,suppress=True)

# ~~~ get data

os.system("tail -n +9 FiberForm_data/char > .data")
os.system("grep -v '^[[:space:]]*$' .data > .dummy")
dummy = np.loadtxt(".dummy", skiprows=1)

# ~~~ get variables names

f = open(".dummy")
header = f.readline().strip()
f.close()

header = header.replace('//', '')
header = header.split('  ')

header = list(filter(None, header))
new_header = []
for variable in header:
    try:
        variable = variable[:variable.index("(")]
    except:
        pass
    new_header.append(variable.strip())

print(new_header)

os.system("rm -f .data .dummy")

nrows = int(dummy.shape[0]/2)
data = dummy[:nrows,:]*1.0

idx_for_T298 = np.argmin(np.abs(data[:,1] - 298))
print(idx_for_T298)

# ~~~ Check which variable to change

import getopt
import sys

arg_list = sys.argv[1:]

opts, args = getopt.getopt(arg_list,"h:",["ki=","kk=","emissivity="])
for opt, arg in opts:
    if opt in ("--ki"):
        ki0 = float(arg)
        print ('Using ki = ', ki0)

        idx = new_header.index("ki")
        kref = data[idx_for_T298,idx]
        data[:,idx] = data[:,idx] - kref + ki0

        idx = new_header.index("kj")
        kref = data[idx_for_T298,idx]
        data[:,idx] = data[:,idx] - kref + ki0
        
    if opt in ("--kk"):
        kk0 = float(arg)
        print ('Using kk = ', kk0)

        idx = new_header.index("kk")
        kref = data[idx_for_T298,idx]
        data[:,idx] = data[:,idx] - kref + kk0
    if opt in ("--emissivity"):
        emis0 = float(arg)
        print ('Using emissivity = ', emis0)

        idx = new_header.index("emissivity")
        emisref = data[idx_for_T298,idx]
        data[:,idx] = data[:,idx] - emisref + emis0

        idx = new_header.index("reflectivity")
        emisref = data[idx_for_T298,idx]
        data[:,idx] = data[:,idx] - emisref + emis0

# ~~~ Output the files

nrows = int(data.shape[0])

f = open("char", "w")
line = ""
for i in range(0,nrows):
    line = line + " ".join(str("%15f" % x) for x in data[i,:]) #+ "\n"
    line = line + "\n"

line = line + "\n"
data[:,0] = 1.0
for i in range(0,nrows):
    line = line + " ".join(str("%15f" % x) for x in data[i,:]) #+ "\n"
    line = line + "\n"
f.write(line)

f.close()

os.system("cp char virgin")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s

## manipulate constant properties file
# f = open("FiberForm_data/constantProperties")
# text = ""
# for line in f:
#     text = text + line
# f.close()
# 
# print(text)

os.system("cp FiberForm_data/constantProperties .")
os.system("chmod -x constantProperties")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s

os.system("cp FiberForm_data/gasProperties .")
os.system("chmod -x gasProperties")
