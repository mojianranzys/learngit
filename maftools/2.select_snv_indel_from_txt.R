#date 2019-10-17
#Author Zhaoys
#select filter_snv_indel from annovar_outfile
#######################
library(pinyin)
library(dplyr)
mypy <- pydic(only_first_letter = TRUE)
annovar_dir <- paste0("/haplox/users/zhaoys/Data/HPCH2018002_09/maftools/annova_txt/")
annovar_name <- list.files(annovar_dir)
#print(annovar_name)
annovar_id <- strsplit(annovar_name,"_")[[1]][5]
n = length(annovar_name)
print(n)
filter_snvindel_dir <- paste0("/haplox/users/zhaoys/Data/HPCH2018002_09/HPCH2018002_09_mutation/")
snvindel_name <- list.files(filter_snvindel_dir)
#print(snvindel_name)
m <- length(snvindel_name)
print(m)
###1st.output a list of annovar_name & snvindel_name & samplename
sampleSheet <- paste0("/haplox/users/zhaoys/Data/HPCH2018002_09/WESPlus_need_information.csv")
csv_df <- read.csv(sampleSheet, header=T, stringsAsFactors = FALSE,  fileEncoding="GBK")
if(FALSE){
  file_list <- NULL
  for(i in 1:n){
    for(j in 1:m){
      annovar_id <- strsplit(annovar_name[i],"_")[[1]][5]
      sample <- csv_df[csv_df[,23] %in% annovar_id,]
      name <- toupper(py(sample[1,4],dic = mypy,sep = ''))
      SAMPLE_NAME <- paste0(name,"_",sample[1,3],"_",annovar_id)
      annovar_type <- strsplit(annovar_name[i],"_")[[1]][6]
      snvindel_id <- strsplit(strsplit(snvindel_name[j],"_")[[1]][4],"[.]")[[1]][1]
      snvindel_type <- strsplit(strsplit(snvindel_name[j],"[.]")[[1]][2],"-")[[1]][1]
      if(annovar_id == snvindel_id && annovar_type == snvindel_type){
        cat(annovar_name[i],snvindel_name[j],SAMPLE_NAME,"\n")
        combine <- cbind(annovar_name[i],snvindel_name[j],SAMPLE_NAME)
        file_list <- rbind(file_list,combine)
        colnames(file_list) <- c("annovar_outfile_name","filter_snvindel_name","SAMPLE_NAME")
      }
    }
  }
  out_list <- paste0("/haplox/users/zhaoys/Data/HPCH2018002_09/maftools/file_list.txt")
  write.table(file_list,file = out_list,quote=FALSE,row.names = FALSE,sep = "\t")
  #print(file_list)
}
###2st.select mutaon from vcf
out_list <- paste0("/haplox/users/zhaoys/Data/HPCH2018002_09/maftools/file_list.txt")
file_list <- read.table(out_list,stringsAsFactors = F,header = T,quote = "",sep = "\t")
print(length(file_list))
result <- NULL
for(i in seq(nrow(file_list))){
  print(file_list[i,])
  annovar_vcf <- paste0(annovar_dir,file_list[i,1])
  snvindel_csv <- paste0(filter_snvindel_dir,file_list[i,2])
  annovar_df <- read.table(annovar_vcf,stringsAsFactors = F,header = F, skip = 1 ,quote = "",sep = "\t")
  #  print(annovar_df[1,])
  snvindel_df <- read.csv(snvindel_csv,stringsAsFactors = F,header = T)
  #  print(snvindel_df[1,])
  information <- paste0(snvindel_df$gene,".*",gsub(">","\\\\>",snvindel_df$base),".*",snvindel_df$VAF_percent_tumor,"%")
  information <- as.data.frame(information)
  #  print(information)
  result <- NULL 
  for(j in seq(nrow(information))){
    #    print(information[j,1])
    filter_annovar <- system(paste0("grep ",information[j,1]," ",annovar_vcf),intern = TRUE)  
    #    print(filter_annovar)
    if(length(filter_annovar) == 0){
      print(information[j,1])
    }
    filter_annovar <- matrix(unlist(strsplit(as.character(filter_annovar[1]),"\t")))
    filter_annovar <- t(filter_annovar)
    result <- rbind(result,filter_annovar)
  }    
  Tumor_Sample_Barcode <- file_list[i,3]
  result <- cbind(Tumor_Sample_Barcode,result)
  #  print(class(result))
  #  print(col(result))
  colnames(result) <- c("Tumor_Sample_Barcode","Chr","Start","End","Ref","Alt","Func.refGene","Gene.refGene","GeneDetail.refGene","ExonicFunc.refGene","AAChange.refGene","cytoBand","genomicSuperDups","esp6500siv2_all","1000g2015aug_all","1000g2015aug_afr","1000g2015aug_eas","1000g2015aug_eur","snp138","SIFT_score","SIFT_pred","Polyphen2_HDIV_score","Polyphen2_HDIV_pred","Polyphen2_HVAR_score","Polyphen2_HVAR_pred","LRT_score","LRT_pred","MutationTaster_score","MutationTaster_pred","MutationAssessor_score","MutationAssessor_pred","FATHMM_score","FATHMM_pred","RadialSVM_score","RadialSVM_pred","LR_score","LR_pred","VEST3_score","CADD_raw","CADD_phred","GERP++_RS","phyloP46way_placental","phyloP100way_vertebrate","SiPhy_29way_logOdds","cosmic87","CLNALLELEID","CLNDN","CLNDISDB","CLNREVSTAT","CLNSIG","Otherinfo","infor_1","infor_2","infor_chr","infor_pos","infor_4","ref_base","alt_base","infor_8","infor_pass","infor_10","infor_depth","ref_infor","alt_infor")
  out_name <- gsub("hg19_multianno","hg19_multianno_fliter",file_list[i,1])
  out_file <- paste0("/haplox/users/zhaoys/Data/HPCH2018002_09/maftools/Filter_annova_txt/",out_name)
  write.table(result,file = out_file,quote=FALSE,row.names = FALSE,sep = "\t")
}
