#!/usr/bin/env bash
#
#SBATCH -J collect_mods # A single job name for the array
#SBATCH -c 4 
#SBATCH -N 1 # on one node
#SBATCH -t 5:00:00 ### 4 hours
#SBATCH --mem 30G
#SBATCH -o ./slurmOut/out.%A_%a.out # Standard output
#SBATCH -e ./slurmOut/out.%A_%a.err # Standard error
#SBATCH -p standard
#SBATCH --account jcbnunez
#SBATCH --array=1-101%50

module load gcc/7.1.0
module load openmpi/3.1.4
module load R/4.1.1
module load gdal
module load proj

Rscript \
--vanilla \
9.window_analysis_allmods.R \
${SLURM_ARRAY_TASK_ID}

date
echo "done"