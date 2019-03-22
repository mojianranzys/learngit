#!/usr/bin/Rscript
print("move attached sheet")

args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
#print(input)
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
#print(sample)
sheet_dir <- paste0("/x01_haplox/users/zhaoys/sheet/")
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[grepl("cfdna|healthcfdna|pedna|ttdna|ffpedna",csv_df[,1]) & grepl("605基因",csv_df[,24]),]
#print(tumor_df[,1])
cmd <- paste0("ls ",path,"*gdna*bam ")
all_tumor <- system(cmd,intern = TRUE)
normal <- gsub(path,"",strsplit(all_tumor,"_rg.bam")[[1]][1])
#print(normal)
germline <- paste0(path,"germline/result/",normal)

system(paste0("perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/female_cancer.list ", germline,".germline.txt ",  germline,".cancer.female.txt ", germline,".nocancer.female.txt ", path,"germline/result","\n",
"perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/male_cancer.list ", germline,".germline.txt ",  germline,".cancer.male.txt ", germline,".nocancer.male.txt ", path,"germline/result","\n",
"perl /haplox/users/wenger/script/germline_trans_v2.pl ", germline,".cancer.female.txt ", germline,"_trans.cancer.female.txt ","\n",
"perl /haplox/users/wenger/script/germline_trans_v2.pl ", germline,".cancer.male.txt ", germline,"_trans.cancer.male.txt "))

system(paste0("python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", germline,"_trans.cancer.female.txt -o ", germline,"_trans.cancer.female.xls ", " \n", 
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", germline,"_trans.cancer.male.txt -o ", germline,"_trans.cancer.male.xls ","\n",
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", germline,".Target_451.txt -o ",germline,".Target_451.xls","\n",
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", germline,".chem_451.txt -o ",germline,".chem_451.xls","\n",
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", germline,".information.txt -o ",germline,".information.xls"))

if(nrow(tumor_df)>=0){
    for(i in seq(nrow(tumor_df))){
        if(tumor_df[i,1] == sample){
            print(tumor_df[i,1])
            system(paste0("cp ",path,"germline/result/",normal,".information.xls ",sheet_dir,"\n",
            "cp ",path,"germline/result/",normal,".Target_451.xls ",sheet_dir,"\n",
            "cp ",path,"germline/result/",normal,".chem_451.xls ",sheet_dir))

            system(paste0("mv ",sheet_dir,normal,".information.xls ",tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-商检605.information.xls ","\n",
            "mv ",sheet_dir,normal,".Target_451.xls ",tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-商检605.Target_451.xls ","\n",
            "mv ",sheet_dir,normal,".chem_451.xls ",tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-商检605.chem_451.xls "))

            if(grepl("男",tumor_df[i,5])){
                system(paste0("cp ",path,"germline/result/",normal,"_trans.cancer.male.xls ",sheet_dir))
                system(paste0("mv ",sheet_dir,normal,"_trans.cancer.male.xls ",tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-商检605_trans.cancer.male.xls "))
            }
            if(grepl("女",tumor_df[i,5])){
                system(paste0("cp ",path,"germline/result/",normal,"_trans.cancer.female.xls ",sheet_dir))
                system(paste0("mv ",sheet_dir,normal,"_trans.cancer.female.xls ",tumor_df[,22],"-",tumor_df[i,3],"-",tumor_df[i,7],"-商检605_trans.cancer.female.xls "))
            }
        }
    }
}
