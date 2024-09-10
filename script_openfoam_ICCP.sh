#!/bin/bash
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name="myjob"
#SBATCH --partition=IllinoisComputes
#SBATCH --account=tricci-ic
#SBATCH --error=myjob.e%j
#SBATCH --output=myjob.o%j

module load gcc/7.2.0
module load openmpi/4.1.0-gcc-7.2.0

source /home/tricci/OpenFOAM-7/etc/bashrc

./Allrun
