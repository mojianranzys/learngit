#!/usr/bin/Rscript
library(stringr)
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
csv_df3 <- NULL
sampleSheet <- paste0("/haplox/users/zhaoys/pancreatic/lijin_dedup_20181130_mutation_df_wesplus_GB18030.csv")
sampleSheet2 <- paste0("/haplox/users/zhaoys/pancreatic/shangjixinxibiao.csv")
out <- paste0("/haplox/users/zhaoys/pancreatic/result")
out_file <- paste0(out,"/oss_snv_indel_bam.csv")
#    csv_df <- read.csv(input, header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8")
    csv_df <- read.csv(sampleSheet, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
    csv_df2 <- read.csv(sampleSheet2, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
    if(nrow(csv_df) >= 1){
        for(i in seq(nrow(csv_df))){
           for(j in seq(nrow(csv_df2))){
            if(csv_df2[j,23] == csv_df[i,1] & grepl("ttdna|ffpedna", csv_df2[j,10])){
                sample <- csv_df2[j,2]
                csv_df3 <- c(csv_df3,sample)
                 }
              }
          }
} 
                if(!file.exists(out_file)){
                   dir.create(out_file, recursive = TRUE)
               
             }else{    
                 print("this file is exist")
            }    
 sink(out_file)
for(i in seq(length(csv_df3))){
          cat(paste0(csv_df3[i],",","oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/sentieon-out-sort-rmdup-bam_node_37/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-bam_rgbam_cfdna.bam", ",", "oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/sentieon-out-sort-rmdup-bam_node_36/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-bam_rgbam_gdna.bam", ",","oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/varscan-annovar-pair_node_18/sample_snv_annovar.hg19_multianno.vcf",",", "oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i],"/tmp/varscan-annovar-pair_node_18/sample_indel_annovar.hg19_multianno.vcf",",","oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/varscan-annovar-pair_node_18/sample.snp.vcf",",","oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/varscan-annovar-pair_node_18/sample.indel.vcf","\n",step = ""))
} 
sink()
zys@x01:/haplox/users/zhaoys/pancreatic 
 $ vi lijin.R
zys@x01:/haplox/users/zhaoys/pancreatic 
 $ cat lijin.R
#!/usr/bin/Rscript
library(stringr)
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
csv_df3 <- NULL
sampleSheet <- paste0("/haplox/users/zhaoys/pancreatic/lijin_dedup_20181130_mutation_df_wesplus_GB18030.csv")
sampleSheet2 <- paste0("/haplox/users/zhaoys/pancreatic/shangjixinxibiao.csv")
out <- paste0("/haplox/users/zhaoys/pancreatic/result")
out_file <- paste0(out,"/oss_snv_indel_bam.csv")
#    csv_df <- read.csv(input, header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8")
    csv_df <- read.csv(sampleSheet, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
    csv_df2 <- read.csv(sampleSheet2, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
    if(nrow(csv_df) >= 1){
        for(i in seq(nrow(csv_df))){
           for(j in seq(nrow(csv_df2))){
            if(csv_df2[j,23] == csv_df[i,1] & grepl("ttdna|ffpedna", csv_df2[j,10])){
                sample <- csv_df2[j,2]
                csv_df3 <- c(csv_df3,sample)
                 }
              }
          }
} 
                if(!file.exists(out_file)){
                   dir.create(out_file, recursive = TRUE)
               
             }else{    
                 print("this file is exist")
            }    
 sink(out_file)
for(i in seq(length(csv_df3))){
          cat(paste0(csv_df3[i],",","oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/sentieon-out-sort-rmdup-bam_node_37/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-bam_rgbam_cfdna.bam", ",", "oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/sentieon-out-sort-rmdup-bam_node_36/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-bam_rgbam_gdna.bam", ",","oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/varscan-annovar-pair_node_18/sample_snv_annovar.hg19_multianno.vcf",",", "oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i],"/tmp/varscan-annovar-pair_node_18/sample_indel_annovar.hg19_multianno.vcf",",","oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/varscan-annovar-pair_node_18/sample.snp.vcf",",","oss://sz-hapres/haplox/hapyun/201811/pair_sentieon_16core64g_", csv_df3[i], "/tmp/varscan-annovar-pair_node_18/sample.indel.vcf","\n",step = ""))
} 
sink()
