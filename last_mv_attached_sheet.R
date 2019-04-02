#!/usr/bin/Rscript
#print("move attached sheet")

args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])

sheet_dir <- paste0("/x01_/haplox/hapreports/4.working/",input,"/zys/")
if(!file.exists(sheet_dir)){
    dir.create(sheet_dir,recursive = TRU)
    }else{
        print("this zys is exists")
    }
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[grepl("cfdna|healthcfdna|pedna|ttdna|ffpedna",csv_df[,1]) & grepl("605基因",csv_df[,24]),]

cmd <- paste0("ls ",path,"*gdna*bam ")
all_tumor <- system(cmd,intern = TRUE)
normal <- gsub(path,"",strsplit(all_tumor,"_rg.bam")[[1]][1])
germline <- paste0(path,"germline/result/",normal)
if(sample != germline ){
    if(grepl("ttdna|ffpedna|pedna|fnadna",sample)){
        type <- "组织有对照605"
    }else{
        type <- "血液605"
    }    
}else{
    type <- "组织无对照"
}

if(nrow(tumor_df)>=0){
    for(i in seq(nrow(tumor_df))){
        if(tumor_df[i,1] == sample){
            system(paste0("cp ",path,"germline/result/",normal,".information.xls ",sheet_dir,"\n",
            "cp ",path,"germline/result/",normal,".Target_451.xls ",sheet_dir,"\n",
            "cp ",path,"germline/result/",normal,".chem_451.xls ",sheet_dir))
            system(paste0("mv ",sheet_dir,normal,".information.xls ",sheet_dir,tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-",type,".information.xls ","\n",
            "mv ",sheet_dir,normal,".Target_451.xls ",sheet_dir,tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-",type,".Target_451.xls ","\n",
            "mv ",sheet_dir,normal,".chem_451.xls ",sheet_dir,tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-",type,".chem_451.xls "))
            if(grepl("男",tumor_df[i,5])){
                system(paste0("cp ",path,"germline/result/",normal,"_trans.cancer.male.xls ",sheet_dir))
                system(paste0("mv ",sheet_dir,normal,"_trans.cancer.male.xls ",sheet_dir,tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-",type,"_trans.cancer.male.xls "))
            }
            if(grepl("女",tumor_df[i,5])){
                system(paste0("cp ",path,"germline/result/",normal,"_trans.cancer.female.xls ",sheet_dir))
                system(paste0("mv ",sheet_dir,normal,"_trans.cancer.female.xls ",sheet_dir,tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-",type,"_trans.cancer.female.xls "))
            }
        }
    }
}
