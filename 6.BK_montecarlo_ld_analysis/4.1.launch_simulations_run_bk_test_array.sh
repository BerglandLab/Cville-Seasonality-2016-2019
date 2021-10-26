#!/usr/bin/env bash
#
#SBATCH -J bk_iterator # A single job name for the array
#SBATCH -c 3
#SBATCH -N 1 # on one node
#SBATCH -t 2:00:00 #<= this may depend on your resources
#SBATCH --mem 12G #<= this may depend on your resources
#SBATCH -o ./slurmOut/bk_iterator.%A_%a.out # Standard output
#SBATCH -e ./slurmOut/bk_iterator.%A_%a.err # Standard error
#SBATCH -p standard
#SBATCH -A jcbnunez
#SBATCH --array=1-1000

module load intel/18.0 intelmpi/18.0
module load goolf/7.1.0_3.1.4
module load gdal proj R/4.0.0

Rscript \
--vanilla \
4.0.run_bk_test.r \
simulation \
${SLURM_ARRAY_TASK_ID}

