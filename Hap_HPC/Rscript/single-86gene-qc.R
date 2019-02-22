#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")
args <- commandArgs(TRUE)
sampleSheet <- paste0("/haplox/nccl/QC-86gene-sample.csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
if(nrow(csv_df) >= 1){
    for(i in seq(nrow(csv_df))){
        if(csv_df[i,10] %in% c("cfdna") & grepl("86gene", csv_df[i,2])){
            rawout <- paste0("/haplox/nccl/cfdna/",csv_df[i,1])
            if(!file.exists(rawout)){
                dir.create(rawout, recursive = TRUE)
                }
            out <- paste0(rawout,"/",csv_df[i,2])
            if(!file.exists(out)){
                dir.create(out, recursive = TRUE)
                }
            print(csv_df[,c(3,23)])
            sh_file <- paste0(out, "/qc_86gene_cfdna.sh")
            sink(sh_file)
            cat(paste0("ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_", 
            csv_df[i,2],"/tmp/captureByRead_ave_depth_node_6/capture/0001.sentieon-bwa-gencore-pileup-no-umi_sortbam_output_5_capture_stat.txt ",out,"\n",
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/captureByRead_ave_depth_node_6/depth/ave_depth.stat ",out,"\n",
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/fastp-16core64g_node_3/reports/ --include *-qc.html ", out,"\n",
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/fastp-16core64g_node_3/reports/ --include *-qc.json ", out,"\n",
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/sentieon-bwa-gencore-pileup-no-umi_node_5/0001.sentieon-bwa-gencore-pileup-no-umi_rgbam_output_5.bam ", out,"\n",
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/sentieon-bwa-gencore-pileup-no-umi_node_5/0001.sentieon-bwa-gencore-pileup-no-umi_sortbam_output_5.bam ", out,"\n",
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/sentieon-bwa-gencore-pileup-no-umi_node_5/0001.sentieon-bwa-gencore-pileup-no-umi_pileup_output_5.pileup ", out,"\n",
            "###----------------------------***--------------------------------\n",
            "mv ", out,"/0001.sentieon-bwa-gencore-pileup-no-umi_sortbam_output_5_capture_stat.txt ",out,"/",csv_df[i,2],"_capture_stat.txt\n",
            "mv ", out,"/ave_depth.stat ",out,"/",csv_df[i,2],"_ave_depth.stat\n",
            "mv ", out,"/0001.sentieon-bwa-gencore-pileup-no-umi_sortbam_output_5.bam ",out,"/",csv_df[i,2],"_sort.bam\n",
            "mv ", out,"/0001.sentieon-bwa-gencore-pileup-no-umi_sortbam_output_5.bam.bai ",out,"/",csv_df[i,2],"_sort.bai\n",
            "mv ", out,"/0001.sentieon-bwa-gencore-pileup-no-umi_rgbam_output_5.bam ",out,"/",csv_df[i,2],"_rg.bam\n",
            "mv ", out,"/0001.sentieon-bwa-gencore-pileup-no-umi_rgbam_output_5.bam.bai ",out,"/",csv_df[i,2],"_rg.bai\n",
            "mv ", out,"/0001.sentieon-bwa-gencore-pileup-no-umi_pileup_output_5.pileup ",out,"/",csv_df[i,2],".pileup\n",step=" "))
            sink()
        }
    }
}
