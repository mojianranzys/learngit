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
if(nrow(csv_df) >= 1){
    for(i in seq(nrow(csv_df))){
        if(csv_df[i,9] %in% c("cfdna","healthcfdna","ttdna") && grepl("451plus", csv_df[i,1]) && grepl("大肠",csv_df[i,25])){
            out <- paste0(rawout,"/",csv_df[i,1])
            cat(csv_df[i,2],"_",csv_df[i,23],"\n")
            out <- paste0(rawout,"/",csv_df[i,1])
            sh_file <- paste0(out, "/sigle_add_baseline.sh")
            if(!file.exists(out)){
                dir.create(out, recursive = TRUE)
                }
            baseline <- paste0(csv_df[i, 2], "_", csv_df[i, 23])   
sink(sh_file)
cat(paste0("python3 /haplox/users/yangbo/crc_baseline.py -i ",out,"/","Annokb_mrbam_",baseline,".indel-nobias-GB18030-baseline-genes378.csv -o ",
out,"/","Single_Annokb_mrbam_",baseline,".indel-nobias-GB18030-baseline-genes378.csv \n",
"python3 /haplox/users/yangbo/crc_baseline.py -i ",out,"/","Annokb_mrbam_",baseline,".snv-nobias-GB18030-baseline-genes378.csv -o ",
out,"/","Single_Annokb_mrbam_",baseline,".snv-nobias-GB18030-baseline-genes378.csv \n",step=""))
sink()
          }
      }
}
