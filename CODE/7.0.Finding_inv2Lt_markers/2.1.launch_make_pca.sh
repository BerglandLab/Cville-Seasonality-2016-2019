#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=40G
#SBATCH --time=24:00:00
#SBATCH --partition=standard
#SBATCH --account=berglandlab

###########################################################################
###########################################################################
# Load R RIVANNA modules
###########################################################################
###########################################################################

module load intel/18.0 intelmpi/18.0
module load goolf/7.1.0_3.1.4
module load gdal proj R/4.0.0

###########################################################################
###########################################################################
# Run R
###########################################################################
###########################################################################

Rscript 1.make_first_pca.r