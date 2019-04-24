#!/usr/bin/Rscript
args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
#print(input)
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
#print(sample)
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
snp_diff <- paste0(path,sample,"_snv-idSNP-filter-diff_1_1.csv")
if(file_test("-f",snp_diff)){
     tmp <- paste0('wc -l ',snp_diff)
     result <- system(tmp,intern= TRUE)
     num <- strsplit(result," ")[[1]][1]
     print(num)
     if(as.numeric(num) >= 40){
         out_dir <- paste0("/haplox/rawout/",input,"/Warning_bamqc_snp_sex/snp_diff/",sample)
         if(!file.exists(out_dir)){
             dir.create(out_dir,recursive = TRUE)
         }
         system(paste0("cp -r ",path,"*snv-idSNP-filter* ",out_dir,"/\n"))
     }
}else{
    print("NO warning diff")
}
