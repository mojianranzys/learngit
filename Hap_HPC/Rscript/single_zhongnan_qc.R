#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")
args <- commandArgs(TRUE)
sampleSheet <- paste0("/haplox/haprs/wuyuling/project/HPCH2018014_colorectal_20190125/00.data/zhongnan_20sample.csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
if(nrow(csv_df) >= 1){
    for(i in seq(nrow(csv_df))){
            rawout <- paste0("/haplox/haprs/wuyuling/project/HPCH2018014_colorectal_20190125/00.data")
            if(!file.exists(rawout)){
                dir.create(rawout, recursive = TRUE)
                }
            print(csv_df[,c(3,23)])
            out <- paste0(rawout,"/qc/",csv_df[i,2])
            if(!file.exists(out)){
                dir.create(out, recursive = TRUE)
                }
            sh_file <- paste0(rawout, "/qc_zhongnan.sh")
            sink(sh_file,append = TRUE)
            cat(paste0("ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_", 
            csv_df[i,2],"/tmp/captureByRead_ave_depth_node_6/capture/0001.sentieon-bwa-gencore-pileup-no-umi_sortbam_output_5_capture_stat.txt ",out,"\n",
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/captureByRead_ave_depth_node_6/depth/ave_depth.stat ",out,"\n",
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/fastp-16core64g_node_3/reports/ --include *-qc.html ", out,"\n",
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/fastp-16core64g_node_3/reports/ --include *-qc.json ", out,"\n",            
            "ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/IDT-fastp-sentieon-gencore-capture-avedepth_",
            csv_df[i,2],"/tmp/sentieon-bwa-gencore-pileup-no-umi_node_5/0001.sentieon-bwa-gencore-pileup-no-umi_rgbam_output_5.bam ", rawout,"\n",
            "###----------------------------***--------------------------------\n",
            "mv ", out,"/0001.sentieon-bwa-gencore-pileup-no-umi_sortbam_output_5_capture_stat.txt ",out,"/",csv_df[i,2],"_capture_stat.txt\n",
            "mv ", out,"/ave_depth.stat ",out,"/",csv_df[i,2],"_ave_depth.stat\n",
            "mv ", out,"/0001.sentieon-bwa-gencore-pileup-no-umi_rgbam_output_5.bam ",rawout,"/",csv_df[i,2],"_rg.bam\n",
            "mv ", out,"/0001.sentieon-bwa-gencore-pileup-no-umi_rgbam_output_5.bam.bai ",rawout,"/",csv_df[i,2],"_rg.bai\n",step=" "))
            sink()
        }
    }
