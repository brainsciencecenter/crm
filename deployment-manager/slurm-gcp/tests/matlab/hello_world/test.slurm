#!/bin/bash
#SBATCH --time=2:00:00
#
#SBATCH --ntasks=1
#
#SBATCH --cpus-per-task=1
#

hostname; date
module load Matlab/R2019a

matlab -nodisplay -nodesktop -nosplash < test.m >/dev/null 2> ${HOME}/matlab_hello_world.txt

