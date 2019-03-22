#!/usr/bin/Rscript
library(stringr)

sampleSheet <- paste0("/haplox/users/zhaoys/MSI/Warning.csv")


out_csv <- paste0("/haplox/users/zhaoys/MSI/pair_msi_tpl.csv")
    csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
#    print(csv_df[,2])
    tumor_df <- csv_df[grepl("ttdna|ffpedna|pedna",csv_df[,7]),]
#    print(tumor_df[,4])
#    print(tumor_df[,12])
    normal_df <- csv_df[grepl("gdna|atdna",csv_df[, 7]),]
    msi <- "oss://sz-hapbin/bioapps/visualmsi/msi.tsv"
    reference <- "oss://sz-hapbin/ctdna_pipeline/clinical/ucsc.hg19/ucsc.hg19.fasta"
if(nrow(tumor_df) >= 1){
    for(i in seq(nrow(tumor_df))){
        for(j in seq(nrow(normal_df))){
            if(tumor_df[i,4] == normal_df[j,4] && tumor_df[i,12]==normal_df[j,12]){
                cat(tumor_df[i,4],normal_df[j,4],tumor_df[i,12],normal_df[j,12],"\n")
                sink(out_csv,append=TRUE)
                cat(paste0(tumor_df[i,17],",",tumor_df[i,18],",",normal_df[i,17],",",normal_df[i,18],",",tumor_df[i,4],",",normal_df[j,4],",",msi,",",reference,",",tumor_df[i,2],"\n",sep=""))
                sink()
            }
        }
    }
}
