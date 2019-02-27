#!/usr/bin/Rscript
library(readr)
print("ffpe_and_cfdna_combine")

args <- commandArgs(TRUE)
input <- args[1]
input2 <- args[2]
#ffpe_and_cfdna
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")
rawout <- paste0("/haplox/rawout/",input)
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
    csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    ffpe_df <- csv_df[grepl("ffpedna|pedna|ttdna",csv_df[,9]) & grepl("86gene-180518",csv_df[,15]),]
    cfdna_df <- csv_df2[grepl("cfdna",csv_df2[,9]) & grepl("86gene-180518",csv_df2[,15]),]
    if(nrow(ffpe_df) >= 1){ 
        for(i in seq(nrow(ffpe_df))){
            for(j in seq(nrow(cfdna_df))){
                if(cfdna_df[j,3] == ffpe_df[i,3]){
                    if(ffpe_df[i,7]=="肺癌"){
                        type <- "lung"
                    }
                    if(ffpe_df[i,7]=="结直肠癌"){
                        type <- "crc"
                    }
                    if(ffpe_df[i,7]=="乳腺癌"){
                        type <- "breast"
                    }
                    if(ffpe_df[i,7]=="胃癌"){
                        type <- "stomach"
                    }
                    if(ffpe_df[i,7]=="胃肠道间质瘤"){
                        type <- "gist"
                    }
                    if(ffpe_df[i,7]=="原发灶不明"){
                        type <- "Null"
                    }
                    cat(ffpe_df[i,1],ffpe_df[i,7]," ")
                    number <- parse_number(ffpe_df[i,24])
                    cat(type,number,"\n")
                    out <- paste0(rawout,"/",ffpe_df[i,1])
                    sh_file <- paste0(out,"/getFFpe_cfdna_combine.sh")
                    if(!file.exists(out)){
                        dir.create(out, recursive = TRUE)
                        }
                    sink(sh_file)
                    if(number == 58){
                    cat(paste0("#----------------------------------indel-----------------------------------------------------\n",
                    "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R \\\n",
                    "/haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes378.bed \\\n",
                    out,"/",ffpe_df[i,2], "_", ffpe_df[i,23],"_indel-",type,31,"-GB18030-baseline.csv \\\n",
                    "/haplox/rawout/",input2,"/",cfdna_df[j,1],"/",cfdna_df[j,2], "_", cfdna_df[j,23],"_indel-",type,31,"-GB18030-baseline.csv \\\n",
                    out,"/",ffpe_df[i,2], "_", ffpe_df[i,23],"_ffpedna_86gene-180518_",ffpe_df[i,23],".indel_combine.csv 0.5 \n",
                    "#----------------------------------snv-----------------------------------------------------\n",
                    "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R \\\n",
                    "/haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes378.bed \\\n",
                    out,"/",ffpe_df[i, 2], "_", ffpe_df[i, 23],"_snv-",type,31,"-GB18030-baseline.csv \\\n",
                    "/haplox/rawout/",input2,"/",cfdna_df[j,1],"/",cfdna_df[j, 2], "_", cfdna_df[j, 23],"_snv-",type,31,"-GB18030-baseline.csv \\\n",
                    out,"/",ffpe_df[i, 2], "_", ffpe_df[i, 23],"_ffpedna_86gene-180518_",ffpe_df[i,23],".snv_combine.csv 0.5 \n",
                    "#----------------------------------cnv-----------------------------------------------------\n",
                    "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getCnv_ff_cf.R \\\n",
                    out,"/cnv/",ffpe_df[i, 1],"_rg_cnv_result.csv \\\n",
                    "/haplox/rawout/",input2,"/",cfdna_df[i,1],"/cnv/",cfdna_df[i,1],"_rg_cnv_result.csv \\\n",
                    out,"/cnv/",ffpe_df[i, 1],"_rg_cnv_tumor_cfdna.csv \n",step=""))
                    }
                    else{
                        cat(paste0("#----------------------------------indel-----------------------------------------------------\n",
                    "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R \\\n",
                    "/haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes378.bed \\\n",
                    out,"/",ffpe_df[i,2], "_", ffpe_df[i,23],"_indel-",type,number,"-GB18030-baseline.csv \\\n",
                    "/haplox/rawout/",input2,"/",cfdna_df[j,1],"/",cfdna_df[j,2], "_", cfdna_df[j,23],"_indel-",type,number,"-GB18030-baseline.csv \\\n",
                    out,"/",ffpe_df[i,2], "_", ffpe_df[i,23],"_ffpedna_86gene-180518_",ffpe_df[i,23],".indel_combine.csv 0.5 \n",
                    "#----------------------------------snv-----------------------------------------------------\n",
                    "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R \\\n",
                    "/haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes378.bed \\\n",
                    out,"/",ffpe_df[i, 2], "_", ffpe_df[i, 23],"_snv-",type,number,"-GB18030-baseline.csv \\\n",
                    "/haplox/rawout/",input2,"/",cfdna_df[j,1],"/",cfdna_df[j, 2], "_", cfdna_df[j, 23],"_snv-",type,number,"-GB18030-baseline.csv \\\n",
                    out,"/",ffpe_df[i, 2], "_", ffpe_df[i, 23],"_ffpedna_86gene-180518_",ffpe_df[i,23],".snv_combine.csv 0.5 \n",
                    "#----------------------------------cnv-----------------------------------------------------\n",
                    "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getCnv_ff_cf.R \\\n",
                    out,"/cnv/",ffpe_df[i, 1],"_rg_cnv_result.csv \\\n",
                    "/haplox/rawout/",input2,"/",cfdna_df[i,1],"/cnv/",cfdna_df[i,1],"_rg_cnv_result.csv \\\n",
                    out,"/cnv/",ffpe_df[i, 1],"_rg_cnv_tumor_cfdna.csv \n",step=""))
                    }
                    if(number > 31){
                        cat(paste0("#-----------------------------------up chem.txt-------------------------------------------\n",
                            "curl haplab.haplox.net/api/report/chemotherapy/",ffpe_df[i,23]," -F chem=@",out,"/germline/result/",ffpe_df[i,1],".chem_",number,".txt\n",step=""))
                    sink()
                    }
                }
            }
        }
}
