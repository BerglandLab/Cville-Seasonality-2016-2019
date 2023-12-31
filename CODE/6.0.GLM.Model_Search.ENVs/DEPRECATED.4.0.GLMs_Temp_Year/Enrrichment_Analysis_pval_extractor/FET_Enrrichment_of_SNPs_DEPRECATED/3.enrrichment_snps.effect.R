### Characterization of GLM SNPs in Charlottesville
### R script

##module load intel/18.0 intelmpi/18.0
##module load goolf/7.1.0_3.1.4
##module load gdal proj R/4.0.0
##R

#args = commandArgs(trailingOnly=TRUE)

#CHR_in = args[1]

#Load libraries
library(data.table)
library(tidyverse)
library(reshape2)
library(magrittr)
library(gmodels)

load("./glm_Cats.Rdata")

#2L	2225744	13154180	2Lt

glm_Cats %>% 
  filter(rnp.clean<0.01,
         mod == "aveTemp") %>% 
         #chr == CHR_in)  %>% 
  #filter(!Effect %in% c("start", "stop", "non") ) %>%
  #mutate(rnp.rank = round(rnp.clean, 1)) %>%
  .[complete.cases(.$Effect),] ->
  glm_Cats_p1
 
glm_Cats_p1  %<>%
    mutate(inversion_stat = case_when(chr == "2L" & pos > 2225744 & pos < 13154180  ~ "inv",
                                      chr == "2L" & pos < 2225744 | pos > 13154180  ~ "outside"))

glm_Cats_p1$inversion_stat[grep("2L", glm_Cats_p1$chr, invert = T)] = "not2L"

glm_Cats_p1$inversion_stat %>% table

glm_Cats_p1$Effect = paste(glm_Cats_p1$Effect, glm_Cats_p1$inversion_stat, sep = "_")

glm_Cats_p1$Effect  %>% table

### build contingency table

glm_Cats_p1 %>%
  group_by(chr, Effect, perm) %>%
  summarize(N = n()) ->
  group_by_PR

#generate categories
group_by_PR$Effect %>%
  .[complete.cases(.)] %>%
  unique() -> Conseq_vector

#generate permutation list
group_by_PR$perm %>%
  .[complete.cases(.)] %>%
  unique() -> Perm_vector

#generate rank pvalue list
group_by_PR %>%
  filter(chr != "X") %>%
  .$chr %>%
  .[complete.cases(.)] %>%
  unique() -> chr_vector



rnp_vec_list = list()
for(j in 1:length(chr_vector)){
 
perm_vec_list = list()
for(i in 1:length(Perm_vector[-1]) ){

Conseq_vec_list = list()
for(k in 1:length(Conseq_vector) ){
    
  group_by_PR %>%
    filter(chr == chr_vector[j],
           Effect == Conseq_vector[k],
           perm == Perm_vector[-1][i]
           ) -> tmp_permutation_focal
  
  group_by_PR %>%
    filter(chr == chr_vector[j],
           Effect == Conseq_vector[k],
           perm == 0
    ) -> tmp_real_focal
  
  group_by_PR %>%
    filter(chr == chr_vector[j],
           Effect != Conseq_vector[k],
           perm == Perm_vector[-1][i]
    ) %>% group_by(chr, perm) %>%
    summarize(N = sum(N)) -> tmp_permutation_other
  
  group_by_PR %>%
    filter(chr == chr_vector[j],
           Effect != Conseq_vector[k],
           perm == 0
    ) %>% group_by(chr, perm) %>%
    summarize(N = sum(N))-> tmp_real_other
  
TMP_yes_CoN_yes = tmp_real_focal$N
TMP_yes_CoN_no = tmp_real_other$N

PERM_yes_CoN_yes = tmp_permutation_focal$N
PERM_yes_CoN_no = tmp_permutation_other$N

### build matrix
tmp_matrix <-
  matrix(rep(NA, 4),
         nrow = 2,
         dimnames = list( c("Real_T", "Perm"),
                          c("Feature", "Not_Feature") ) )

if( length(TMP_yes_CoN_yes) > 0  & 
    length(TMP_yes_CoN_no) > 0  &
    length(PERM_yes_CoN_yes) > 0  &
    length(PERM_yes_CoN_no) > 0 ) {
  print("pass")
  
tmp_matrix[1,1] =  TMP_yes_CoN_yes
tmp_matrix[1,2] =  TMP_yes_CoN_no
tmp_matrix[2,1] = PERM_yes_CoN_yes
tmp_matrix[2,2] = PERM_yes_CoN_no

fet_tmp <- fisher.test(tmp_matrix)

results_df =
data.frame(
chr =   chr_vector[j],
Conseq =  Conseq_vector[k],
vsPerm =  Perm_vector[-1][i],
p.val = fet_tmp$p.value, 
OR = fet_tmp$estimate,
OR_low = fet_tmp$conf.int[1],
OR_high = fet_tmp$conf.int[2]
)

Conseq_vec_list[[k]] = results_df

} else{ print("does not pass filter")} # if logical statement

}# close k

perm_vec_list[[i]] = do.call(rbind, Conseq_vec_list)
}# close i

rnp_vec_list[[j]] = do.call(rbind, perm_vec_list)
}# close j

final_output = do.call(rbind, rnp_vec_list)


save(final_output,
     file = paste("all_chrs.Effect","final_output","Rdata", sep = "."))


final_output %>%
  separate(Conseq, into = c("Effect", "inv_st"), sep = "_") %>% 
  group_by(Effect, chr, inv_st) %>%
  mutate(OR_m = ci(OR)[1],
         OR_sd = sd(OR)
         #OR_h = ci(OR)[3]
         ) -> data_formatted_for_graph

data_formatted_for_graph %>%
  ggplot(aes(
    x=Effect,
    y=log2(OR_m),
    ymin=log2(OR_m-OR_sd),
    ymax=log2(OR_m+OR_sd),
    color =inv_st
  )) +
  geom_errorbar(width = 0.01, position=position_dodge(width=0.5)) +
  geom_point(position=position_dodge(width=0.5)) +
  coord_flip() +
  theme_bw() +
  ggtitle("RNPv < 0.01, Enrrichment") + 
  geom_hline(yintercept = 0, linetype = "dashed") +
  facet_wrap(~chr, scales = "free") ->
  OR_plot

ggsave(OR_plot,
       file = "OR_plot.Effect.pdf",
       width = 5.5,
       height = 4)

#####
#####