#!/usr/bin/env bash
#PBS -l nodes=1:ppn=28,walltime=05:00:00
#PBS -N fp_exact
#PBS -q long

module load torque
module load shared
module load anaconda/3


source activate /gpfs/projects/LynchGroup/GIS_tools/
cd /gpfs/projects/LynchGroup/GIS_tools/Footprint_script
python3 footprint_exact.py --input '/gpfs/projects/LynchGroup/Orthoed' --output '/gpfs/projects/LynchGroup/Footprints/orthoed.shp' --cores 27 > footprint_out.txt 2> footprint_error.txt
