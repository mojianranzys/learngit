#!/usr/bin/Rscript
library(stringr)

sampleSheet <- paste0("/haplox/users/zhaoys/Warning.csv")


out_csv <- paste0("/haplox/users/zhaoys/Hap_HPC/pair_msi_tpl.csv")
    csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    print(csv_df2[,1])
    tumor_df <- csv_df[csv_df1[, 9] %in% c("ttdna", "ffpedna", "pedna") & grepl("451plus", csv_df1[,1]) & grepl("肠康",csv_df1[,25]), ]
    normal_df <- csv_df[grepl("gdna|atdna",csv_df2[, 1] ) & grepl("wesplus|451plus",csv_df2[, 1] ), ]
    msi <- "oss://sz-hapbin/bioapps/visualmsi/msi.tsv"

    for(i in seq(nrow(tumor_df))){
        for(j in seq(nrow(normal_df))){
            if(tumor_df[i,4] == normal_df[j,4] && tumor_df[i,12]==normal_df[i,12]){
                sink(out_csv)
                cat(paste0(tumor_df[i,17],",",tumor_df[i,18]),",",normal_df[i,17],",",normal_df[i,18],msi,"\n",sp=""))
                sink()
            }
        }
    }
