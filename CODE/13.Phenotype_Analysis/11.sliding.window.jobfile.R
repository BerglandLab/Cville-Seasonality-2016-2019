# module load gcc/7.1.0  openmpi/3.1.4 R/4.1.1; R

### library
library(data.table)
library(foreach)

### pheno file list
#pheno.dir1 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withoutGRMs/NewPhenoOutputsWithoutGRMS"
pheno.dir2 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withoutGRMs/Dariaphenotypes"
pheno.dir3 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withGRMs/Dariaphenotypes"
pheno.dir4 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withGRMs/Cynthiaphenotypes"
pheno.dir5 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withoutGRMs/Cynthiaphenotypes"
#pheno.dir6 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withGRMs/JanGWAS"

#pheno.files <- list.files(path=c(pheno.dir1, pheno.dir2, pheno.dir3, pheno.dir4), all.files=T, full.names=T, recursive=T)
pheno.files <- list.files(path=c(pheno.dir2, pheno.dir5), all.files=T, full.names=T, recursive=T)



glm.files = c(0:100) #the number of glms (observed and permutations) used
#can manually make job paths like this
# fl <- paste0("/scratch/bal7cg/Deficiency-Line-confirmation/Alan.modelF.files/F", c(0:101), ".Rdata")

### nTotal jobs
nJobs <- 1000

### combos
df <- foreach(i=glm.files, .combine="rbind")%do%{
  # i <- glm.files[2]
  tmp <- data.table(glm=i, gwas=pheno.files)
  tmp[,job:=c(rep(1:24, each= 9), rep(25,7))]#change these values to match the dimensions of phenofiles
  tmp[,job:=job + ((which(i==glm.files)-1) * 26)]
  #tmp[,job:=which(i==glm.files)]
}

table(df[,list(n=length(unique(glm)), .N), list(job)]$n)

### save

write.csv(df, "./nogrm.newmodels.job.csv", row.names = F, quote = F)
