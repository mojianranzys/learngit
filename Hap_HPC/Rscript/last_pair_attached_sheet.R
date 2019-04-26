#!/usr/bin/Rscript
#print("move attached sheet")

args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
data_id <- strsplit(sample,"_")[[1]][5]

sheet_dir <- paste0(path,data_id)
if(!file.exists(sheet_dir)){
    dir.create(sheet_dir,recursive = TRUE)
    }else{
        print("this data_id is exists")
    }
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[grepl("cfdna|healthcfdna|pedna|ttdna|ffpedna",csv_df[,1]) & grepl("605基因",csv_df[,24]),]

cmd <- paste0("ls ",path,"*gdna*bam ")
all_tumor <- system(cmd,intern = TRUE)
normal <- gsub(path,"",strsplit(all_tumor,"_rg.bam")[[1]][1])
germline <- paste0(path,"germline/result/",normal)
if(nrow(tumor_df)>=0){
    for(i in seq(nrow(tumor_df))){
        if(tumor_df[i,1] == sample){
            system(paste0("cp ",path,"germline/result/",normal,".information.xls ",sheet_dir,"\n",
            "cp ",path,"germline/result/",normal,".Target_451.xls ",sheet_dir,"\n",
            "cp ",path,"germline/result/",normal,".chem_451.xls ",sheet_dir,"\n",
            "cp ",path,"cnv/",sample,"_rg_cnv_result.csv ",sheet_dir,"\n",
            "cp -r ",path,"fusionscan ",sheet_dir,"\n",
            "cp -r ",path,"fusion ",sheet_dir,"\n",
            "cp -r ",path,"MutScan ",sheet_dir,"\n",
            "cp -r ",path,"virus ",sheet_dir,"\n",
            "cp -r ",path,"Annokb_mrbam* ",sheet_dir))
            if(grepl("男",tumor_df[i,5])){
                system(paste0("cp ",path,"germline/result/",normal,"_trans_cancer_male.xls ",sheet_dir))
            }
            if(grepl("女",tumor_df[i,5])){
                system(paste0("cp ",path,"germline/result/",normal,"_trans_cancer_female.xls ",sheet_dir))
            }
        }
    }
}

