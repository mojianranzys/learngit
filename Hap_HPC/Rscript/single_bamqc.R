#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
input <- args[1]
#only ttdna wesplus
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
rawout <- paste0("/haplox/rawout/",input)
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[csv_df[,9] %in% c("ttdna","ffpedna","atdna") & grepl("wesplus", csv_df[,1]) & grepl("肠康",csv_df[,25]),]
print(tumor_df[,1])
if(nrow(tumor_df) >= 1){
    for(i in seq(nrow(tumor_df))){
        out <- paste0(rawout,"/ffpedna_vs_gdna/",tumor_df[i,1])
        sh_file <- paste0(out, "/sigle_bamqc.sh")
        if(!file.exists(out)){
            dir.create(out, recursive = TRUE)
            }
        baseline <- paste0(tumor_df[i, 2], "_", tumor_df[i, 23])
        bamqc_cfdna <- paste0(out,"/BamQC/",tumor_df[i,1],"/bam_pileup_QC/",tumor_df[i,1],".bam_qc.csv")
        sink(sh_file)
        cat(paste0("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/single_bamqc_",
        tumor_df[i, 1], "/tmp/rgbam_captureByBase_depth_maprate_node_38/ ", out, "/BamQC/",tumor_df[i,1],"/\n",
        "###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_rgbam_output_3/',tumor_df[i,1],'/"'," ", 
        out,"/BamQC/",tumor_df[i,1],"/bam_pileup_QC/*\n",
        "###\n","mv ", out,"/BamQC/",tumor_df[i,1],"/capture/0001.sentieon-bwa-gencore-pileup-no-umi_rgbam_output_3.bam_capture_stat.txt ",
        out,"/BamQC/",tumor_df[i,1],"/capture/", tumor_df[i,1],"_capture_stat.txt\n",
        "###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_rgbam_output_3/',tumor_df[i,1],'/"'," ",
        out,"/BamQC/",tumor_df[i,1],"/depth/*\n",
        "###\n",'curl haplab.haplox.net/api/report/depth-new -F "import_file=@',bamqc_cfdna,'"',"\n",sep=""))
        sink()
        }
    }