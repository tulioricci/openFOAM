#!/bin/bash

#SBATCH --job-name=PATO
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --time=24:00:00
#SBATCH --partition=pbatch

module unload intel-classic/2021.6.0-magic mvapich2/2.3.7
module load gcc/11.2.1 openmpi/4.1.2 cmake/3.23.1
source /g/g92/tulio/openFOAM/OpenFOAM-7/etc/bashrc
source /g/g92/tulio/openFOAM/pato-3.1/bashrc

if [ ! -d 0.000000 ]; then 
  sh setFields.sh
fi
srun -N 1 --ntasks 6 PATOx -parallel
