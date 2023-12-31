#!/bin/bash
#SBATCH --ntasks-per-node=4
#SBATCH --mem=40G
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

Rscript 1.make_glm_snp_subobject.R