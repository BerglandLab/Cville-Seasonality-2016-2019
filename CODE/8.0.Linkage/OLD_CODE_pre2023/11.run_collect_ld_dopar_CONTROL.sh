#!/bin/bash
#SBATCH --ntasks-per-node=15
#SBATCH --mem=150G
#SBATCH --time=12:00:00
#SBATCH --partition=standard
#SBATCH --account=jcbnunez

###########################################################################
###########################################################################
# Load R RIVANNA modules
###########################################################################
###########################################################################

module load gcc/7.1.0
module load openmpi/3.1.4
module load R/4.1.1

###########################################################################
###########################################################################
# Run R
###########################################################################
###########################################################################

Rscript 11.collect_and_bind_ld_dopar_CONTROL.R