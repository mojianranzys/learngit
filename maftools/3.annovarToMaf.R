rm(list = ls())
library(maftools)
filter_annovar_dir <- paste0("E:/R-3.5.3/zys_learnR/Data/maftools/Filter_annova_txt/")
file_name <- list.files(filter_annovar_dir)
n = length(file_name)
print(n)
for(i in 1:n){
  print(file_name[i])
  filter_annovar_txt = paste0(filter_annovar_dir,file_name[i])
  annovar_maf <- annovarToMaf(annovar = filter_annovar_txt,
                              Center = "Haplox",
                              refBuild = "GRCh37",
                              tsbCol = "Tumor_Sample_Barcode",
                              table = "refGene",
                              sep = "\t")
  maf_name <- gsub(".txt",".maf",file_name[i])
  maf_out <- paste0("E:/R-3.5.3/zys_learnR/Data/maftools/File_maf/",maf_name)
  write.table(annovar_maf,file = maf_out,quote =FALSE,row.names=FALSE,sep="\t")
}

###2nd.merg maf_file
maf_dir <- paste0("E:/R-3.5.3/zys_learnR/Data/maftools/File_maf/")
maf_name <- list.files(maf_dir)
dir <- paste0(maf_dir,maf_name)
#print(maf_name)
m <- length(maf_name)
print(m)
print(dir[1])
merge_data <- read.table(file = dir[1],header = TRUE,stringsAsFactors = FALSE,sep="\t")
out_maf <- paste0("E:/R-3.5.3/zys_learnR/Data/maftools/merge_maf/sample_merge.maf")
for(i in 2:m){
  new_data <- read.table(file = dir[i],header = TRUE,stringsAsFactors = FALSE,sep="\t")
  merge_data <- rbind(merge_data,new_data)
}
write.table(merge_data,file=out_maf,quote=FALSE,row.names = FALSE,sep="\t")

###3st.find t_vaf
maf_df <- read.table(out_maf,stringsAsFactors = F,header = T,sep="\t")
Tumor_vaf <- NULL
for(i in seq(nrow(maf_df))){
  tmp <- as.numeric(gsub("%","",strsplit(maf_df[i,74],"[:]")[[1]][6]))/100
  Tumor_vaf <- rbind(Tumor_vaf,tmp) 
}
maf_df <- cbind(maf_df,Tumor_vaf)
write.table(maf_df,file = out_maf, quote=FALSE,row.names = FALSE,sep = "\t")

###

