#!/bin/bash
#SBATCH --time=2:00:00
#
#SBATCH --ntasks=1
#

hostname; date
module load Matlab/R2019a

srun --ntasks=1 --cpus-per-task=1 matlab -nodisplay -nodesktop -nosplash < shallow_water_model.m
