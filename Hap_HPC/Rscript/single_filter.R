#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
input <- args[1]
#only cfdna/ttdna no gdna & 451plus
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
rawout <- paste0("/haplox/rawout/",input)
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[csv_df[,9] %in% c("cfdna","ttdna") & grepl("451plus", csv_df[,1]) & grepl("大肠",csv_df[,25]),]
print(tumor_df[,1])
if(nrow(tumor_df) >= 1){
    for(i in seq(nrow(tumor_df))){
        out <- paste0(rawout,"/",tumor_df[i,1])
        out <- paste0(rawout,"/",tumor_df[i,1])
        sh_file <- paste0(out, "/sigle_last_filter.sh")
        if(!file.exists(out)){
            dir.create(out, recursive = TRUE)
            }
        baseline <- paste0(tumor_df[i, 2], "_", tumor_df[i, 23])
        sink(sh_file)
       if(tumor_df[i,9]=="ttdna"){
            cat(paste0("Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/single_76_filter.R  ",
            out,"/","Single_Annokb_mrbam_",baseline,".indel-nobias-GB18030-baseline-genes378.csv 2 \n",
            "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/single_76_filter.R  ",
            out,"/","Single_Annokb_mrbam_",baseline,".snv-nobias-GB18030-baseline-genes378.csv 2 \n",step=""))
            }
            if(tumor_df[i,9]=="cfdna"){
                cat(paste0("Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/single_76_filter.R  ",
                out,"/","Single_Annokb_mrbam_",baseline,".indel-nobias-GB18030-baseline-genes378.csv 0.5 \n",
                "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/single_76_filter.R  ",
                out,"/","Single_Annokb_mrbam_",baseline,".snv-nobias-GB18030-baseline-genes378.csv 0.5 \n",step=""))
           }
           sink()
        }
    }
