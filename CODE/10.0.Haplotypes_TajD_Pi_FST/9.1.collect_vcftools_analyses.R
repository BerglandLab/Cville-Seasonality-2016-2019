### Collect VCFTools analyses
### 

library(tidyverse)
library(magrittr)
library(data.table)
library(reshape2)
library(foreach)
library(doParallel)

inversion_map <- "/project/berglandlab/Dmel_genomic_resources/Inversions/InversionsMap_hglft_v6_inv_startStop.txt"
inv.dt <- fread(inversion_map)
setnames(inv.dt, "chrom", "chr.x")


####### Load subset
####### Load subset
####### Load subset
####### Load subset
####### Load subset

files_pi = system("ls ./Pi_D_subsets | grep 'pi'", intern = T)

pi_merge <- foreach(i=1:length(files_pi), .combine = "rbind")%do%{
  info <- strsplit(files_pi[i], split = "\\.")[[1]]
  tmp <- fread(paste("./Pi_D_subsets/", files_pi[i], sep = ""))
  tmp %>%
    mutate(pop = info[2],
           type = info[5],
           resolution = info[3]) %>%
    dplyr::select(PI,  BIN_START, pop, type, resolution) %>%
    melt(id = c("BIN_START", "pop", "type", "resolution")) -> tmp_parsed
  return(tmp_parsed)
}

files_D = system("ls ./Pi_D_subsets | grep 'Taj'", intern = T)

D_merge <- foreach(i=1:length(files_D), .combine = "rbind")%do%{
  info <- strsplit(files_D[i], split = "\\.")[[1]]
  tmp <- fread(paste("./Pi_D_subsets/", files_D[i], sep = ""))
  tmp %>%
    mutate(pop = info[2],
           type = info[5],
           resolution = info[3]) %>%
    dplyr::select(TajimaD,  BIN_START, pop, type, resolution) %>%
    melt(id = c("BIN_START", "pop", "type", "resolution")) -> tmp_parsed
  return(tmp_parsed)
}


rbind(pi_merge,D_merge ) -> sub_pi_d_parsed

###### plot
###### plot
###### plot
###### plot
###### plot
###### plot


###### save
###### 
save(inv.dt, sub_pi_d_parsed, file = "pi_D_datforplot.Rdata")