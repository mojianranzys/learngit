#!/usr/bin/Rscript

args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
#print(input)
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
#print(sample)
sheet_dir <- paste0("/x01_haplox/hapreports/3.遗传咨询待发送/00.待审核x小panel/")
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
#print(csv_df[,15])
tumor_df <- csv_df[grepl("cfdna|healthcfdna|pedna|ttdna|ffpedna",csv_df[,1]) & grepl("86gene-180518",csv_df[,15]) ,]
#print(tumor_df[,1])
#print(tumor_df[,24])
if(nrow(tumor_df)>=1){
    for(i in seq(nrow(tumor_df))){
        if(tumor_df[i,1] == sample){
            if(grepl("11|90",tumor_df[i,24])){
                system(paste0("cp ",path,"germline/result/",sample,".chem_90.xls ",sheet_dir,"\n",
                "mv ",sheet_dir,sample,".chem_90.xls ",sheet_dir,tumor_df[i,22],"-",tumor_df[i,3],"-",tumor_df[i,7],".chem_90.xls ","\n"))
            }
            if(grepl("51",tumor_df[i,24])){
                system(paste0("cp ",path,"germline/result/",sample,".chem_51.xls ",sheet_dir,"\n",
                "mv ",sheet_dir,sample,".chem_51.xls ",sheet_dir,tumor_df[i,22],"-",tumor_df[i,3],"-",tumor_df[i,7],".chem_51.xls ","\n"))
            }
            if(grepl("37",tumor_df[i,24])){
                system(paste0("cp ",path,"germline/result/",sample,".chem_37.xls ",sheet_dir,"\n",
                "mv ",sheet_dir,sample,".chem_51.xls ",sheet_dir,tumor_df[i,22],"-",tumor_df[i,3],"-",tumor_df[i,7],".chem_37.xls ","\n"))
            }
       }
   }
}
