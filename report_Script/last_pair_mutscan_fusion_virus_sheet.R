#!/usr/bin/Rscript
#print("move attached sheet")

args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
#print(sample)
data_id <- strsplit(sample,"_")[[1]][5]

sheet_dir <- paste0(path,data_id)
if(!file.exists(sheet_dir)){
    dir.create(sheet_dir,recursive = TRUE)
    }else{
        print("this data_id is exists")
    }
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[grepl("cfdna|healthcfdna|pedna|ttdna|ffpedna",csv_df[,1]) & grepl("451plus",csv_df[,1]),]
germline_path <- paste0(path,"germline/result/")
cmd <- paste0("ls ",germline_path,"*.germline.txt")
all_tumor <- system(cmd,intern = TRUE)
normal <- gsub(germline_path,"",strsplit(all_tumor,".germline.txt")[[1]][1])
print(normal)
gdna_data_id <- strsplit(normal,"_")[[1]][5]
#print(normal)
germline <- paste0(path,"germline/result/",normal)
system(paste0("curl haplab.haplox.net/api/report/gdna/",data_id,"?gdna_data_id=",gdna_data_id))
if(nrow(tumor_df)>=0){
    for(i in seq(nrow(tumor_df))){
        if(tumor_df[i,1] == sample){
            system(paste0("Rscript /haplox/users/zhaoys/Script/last_mutscan_fusion_virus.R ",path,"\n",
                          "python3 /haplox/users/zhaoys/Script/last_pair_combine_sheet.py -d ",path,"\n",
                          "Rscript /haplox/users/zhaoys/Script/last_mv_ffpevcf.R ",path,"\n",
                          "Rscript /haplox/users/zhaoys/Script/single_contamination_rate.R ",path,"\n",              
            "cp ",path,"germline/result/",normal,".information.xls ",sheet_dir,"\n",
            "cp ",path,"germline/result/",normal,".Target_451.xls ",sheet_dir,"\n",
            "cp ",path,"germline/result/",normal,".chem_451.xls ",sheet_dir,"\n",
            "cp ",path,"cnv/",sample,"_rg_cnv_result.csv ",sheet_dir,"\n",
            "cp -r ",path,"fusionscan ",sheet_dir,"\n",
            "cp -r ",path,"fusion ",sheet_dir,"\n",
            "cp -r ",path,"MutScan ",sheet_dir,"\n",
            "cp -r ",path,"virus ",sheet_dir,"\n",
            "cp -r ",path,"Visual_msi ",sheet_dir,"\n",
            "cp -r ",path,"Combine_mutscan_fusion_virus/mutscan_fusion_virus.xlsx ",sheet_dir,"\n",
            "cp -r ",path,"Annokb_mrbam* ",sheet_dir))
            if(grepl("男",tumor_df[i,5])){
                system(paste0("cp ",path,"germline/result/",normal,"_trans_cancer_male.xls ",sheet_dir))
            }
            if(grepl("女",tumor_df[i,5])){
                system(paste0("cp ",path,"germline/result/",normal,"_trans_cancer_female.xls ",sheet_dir))
            }
        }
    }
}else{print("NO this sample")}
cat("--------Finished------\n")

