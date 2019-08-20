#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
csv_df3 <- NULL
input <- args[1]
input2 <- args[2]
#cfDNA_vs_gDAN
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")
rawout <- paste0("/haplox/rawout/",input)
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
#    csv_df <- read.csv(input, header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8")
    csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    tumor_df <- csv_df[csv_df[,9] %in% c("cfdna","healthcfdna","pedna") & grepl("肠康",csv_df[,25]),]
    print(tumor_df[,c(2,23)])
    tumor_df$normal = rep(NA, nrow(tumor_df))
    if(nrow(tumor_df) >= 1){ 
        for(i in seq(nrow(tumor_df))){
           for(j in seq(nrow(csv_df2))){
            if(csv_df2[j,3] == tumor_df[i,3] && grepl("gdna|saldna|healthdna|ntdna|atdna",csv_df2[j,9])){
                tumor_df[i,"normal"] <- csv_df2[j,1]
                out <- paste0(rawout,"/",tumor_df[i,1])
                csv_df3 <- c(csv_df3,out)
                sh_file <- paste0(out,"/last_pair_capture_depth.sh")
                if(!file.exists(out)){
                    dir.create(out, recursive = TRUE)
                }   
                sink(sh_file)
                cat(paste("ossutil cp -r oss://sz-hapres/haplox/hapyun/201902/pair_mutant_pe_sentieon_gencore_IDT_16core64g_",
tumor_df[i, 1], "/tmp/captureByRead_ave_depth_node_39/depth/ave_depth.stat ", out, "/Capture_Depth_cfdna/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201902/pair_mutant_pe_sentieon_gencore_IDT_16core64g_",
tumor_df[i, 1], "/tmp/captureByRead_ave_depth_node_39/capture/ --include *capture_stat.txt ", out, "/Capture_Depth_cfdna/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201902/pair_mutant_pe_sentieon_gencore_IDT_16core64g_",
tumor_df[i, 1], "/tmp/captureByRead_ave_depth_node_40/capture/ --include *capture_stat.txt ", out, "/Capture_Depth_gdna/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201902/pair_mutant_pe_sentieon_gencore_IDT_16core64g_",
tumor_df[i, 1], "/tmp/captureByRead_ave_depth_node_40/depth/ave_depth.stat ", out, "/Capture_Depth_gdna/\n",
"#--------------------------------------------------\n",
"###\n","mv ", out,"/Capture_Depth_cfdna/0001.sentieon-bwa-gencore-pileup-no-umi_cfdna_sortbam_output_4_capture_stat.txt ",
out,"/Capture_Depth_cfdna/", tumor_df[i,1],"_sortbam_capture_stat.txt\n",
"###\n","mv ", out,"/Capture_Depth_gdna/0001.sentieon-bwa-gencore-pileup-no-umi_gdna_sortbam_output_3_capture_stat.txt ",
out,"/Capture_Depth_gdna/", tumor_df[i,"normal"],"_sortbam_capture_stat.txt\n",
"###\n","mv ", out,"/Capture_Depth_cfdna/ave_depth.stat ",out,"/Capture_Depth_cfdna/",tumor_df[i,1],"_ave_depth.stat\n",
"###\n","mv ", out,"/Capture_Depth_gdna/ave_depth.stat ",out,"/Capture_Depth_gdna/",tumor_df[i,"normal"],"_ave_depth.stat\n",
"###\n","mkdir ",out,"/captureByRead_ave_depth\n","###\n","mv ",out,"/Capture_Depth*/* ", out,"/captureByRead_ave_depth\n",
"###\n","rm -r ",out,"/Capture_Depth*\n",
"###\n","python /haplox/users/zhaoys/Hap_HPC/qc_up.py -d ",out,"/\n",sep = ""))
                 sink()
            }
        }
    }
}else{
        print("no")
    }
