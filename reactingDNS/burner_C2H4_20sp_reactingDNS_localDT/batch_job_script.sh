#!/bin/bash

#SBATCH --job-name=check_slpm_eps=1.000_phi=1.00
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --ntasks-per-node=5
#SBATCH --partition=pbatch

module unload intel-classic/2021.6.0-magic mvapich2/2.3.7
module load gcc/11.2.1 openmpi/4.1.2 cmake/3.23.1
source /g/g92/tulio/openFOAM/OpenFOAM-8/etc/bashrc

sh setFields.sh
srun -N 1 --ntasks 5 reactingDNS -parallel
