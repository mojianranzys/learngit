#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
csv_df3 <- NULL
input <- args[1]
input2 <- args[2]
#ttDNA_wesplus_vs_gDAN
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")
rawout <- paste0("/haplox/rawout/",input)
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
#    csv_df <- read.csv(input, header=FALSE, stringsAsFactors = FALSE, fileEncoding="latin1", encoding="UTF-8")
    csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE, fileEncoding="latin1", encoding="UTF-8")
    csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE, fileEncoding="latin1", encoding="UTF-8")
    tumor_df <- csv_df[csv_df[,9] %in% c("cfdna","healthcfdna") & grepl("451plus", csv_df[,1]),]
    print(tumor_df[,c(2,23)])
    tumor_df$normal = rep(NA, nrow(tumor_df))
    if(nrow(tumor_df) >= 1){
        for(i in seq(nrow(tumor_df))){
           for(j in seq(nrow(csv_df2))){
              if(csv_df2[j,3] == tumor_df[i,3] & grepl("atdna|ntdna|gdna",csv_df2[j,9]) & grepl("451plus", csv_df2[j,1])){
                out <- paste0(rawout,"/",tumor_df[i,1])
                csv_df3 <- c(csv_df3,out)
                sh_file <- paste0(rawout,"/muilt_pair_cfdna_451plus.sh")
                
                if(!file.exists(out)){
                    dir.create(out, recursive = TRUE)
                }
          }     
      }
   }
}
                sink(sh_file,append = TRUE)
for ( i in seq(length(csv_df3))){
      cat(paste0("###\n","nohup bash ",csv_df3[i],"/last_pair_451plus_hapyun_sentieon.sh &","\n",step = ""))          
}
sink()