#!/usr/bin/Rscript
library(stringr)

sampleSheet <- paste0("/haplox/users/zhaoys/MSI/Warning.csv")

csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[grepl("ttdna|ffpedna",csv_df[,7]),]
print(tumor_df[,2])
rawout <- paste0("/haplox/users/zhaoys/MSI/")

if(nrow(tumor_df) >= 1){
    for(i in seq(nrow(tumor_df))){
        data_id <- stringi::stri_reverse(strsplit(stringi::stri_reverse(tumor_df[i,2]),"_")[[1]][1])
        out <- paste0(rawout,tumor_df[i,2])
        if(!file.exists(out)){
              dir.create(out, recursive = TRUE)
        }
        msi_sh <- paste0(out,"/download.sh")
        sink(msi_sh)
        cat(paste0("ossutil cp oss://sz-hapres/haplox/hapyun/201903/fastp-sentieon-msi_",tumor_df[i,2],"/tmp/Visual_msi_node_7/0001.Visual_msi_html_output_7.html ",out,"/\n",
        "ossutil cp oss://sz-hapres/haplox/hapyun/201903/fastp-sentieon-msi_",tumor_df[i,2],"/tmp/Visual_msi_node_7/0001.Visual_msi_json_output_7.json ",out,"/\n",
        "mv ",out,"/0001.Visual_msi_html_output_7.html ",out,"/",data_id,".html","\n",
        "mv ",out,"/0001.Visual_msi_json_output_7.json ",out,"/",data_id,".json","\n",sep=""))
        sink()
    }
}
