# module load gcc/7.1.0  openmpi/3.1.4 R/4.1.1; R

### library
  library(data.table)
  library(foreach)

### pheno file list
  #pheno.dir1 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withoutGRMs/NewPhenoOutputsWithoutGRMS"
  #pheno.dir2 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withoutGRMs/OriginalOutputsWithoutGRMS"
  #pheno.dir3 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withGRMs/NewPhenoOutputsWithGRMS"
  #pheno.dir4 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withGRMs/OriginalOutputsWithGRMS"
  pheno.dir5 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withoutGRMs/JanGWAS"
  pheno.dir6 <- "/project/berglandlab/Yang_Adam/YangsGWAS/GWAS_withGRMs/JanGWAS"

  #pheno.files <- list.files(path=c(pheno.dir1, pheno.dir2, pheno.dir3, pheno.dir4), all.files=T, full.names=T, recursive=T)
  pheno.files <- list.files(path=c(pheno.dir5, pheno.dir6), all.files=T, full.names=T, recursive=T)



### perm file list
  glm.files <- list.files("/project/berglandlab/thermal_glm_dest/processedGLM/", "glm.out.VA_ch_", full.names=T)

### nTotal jobs
  nJobs <- 1000

### combos
  df <- foreach(i=glm.files, .combine="rbind")%do%{
    # i <- glm.files[2]
    tmp <- data.table(glm=i, gwas=pheno.files)
    tmp[,job:=c(rep(1:25, each=8), 26, 26)]
    tmp[,job:=job + ((which(i==glm.files)-1) * 26)]
    #tmp[,job:=which(i==glm.files)]
  }

  table(df[,list(n=length(unique(glm)), .N), list(job)]$n)

### save
  write.csv(df, file="~/Overwintering_18_19/pheno/pheno_jobs2.csv", quote=F, row.names=F)
