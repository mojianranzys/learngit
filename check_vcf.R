#!usr/bin/Rscript
library(stringr)
samplesheet <- paste0("/haplox/users/zhaoys/data/check_vcf/jiefangjun_cfdna_information_2.csv")
samplesheet2 <- paste0("/haplox/users/zhaoys/data/check_vcf/jiefangjun_ttdna_mutation_2.csv")
csv_df <- read.csv(samplesheet, header=TRUE, stringsAsFactors = FALSE, na="", fileEncoding="GBK")
csv_df2 <- read.csv(samplesheet2,header=TRUE, stringsAsFactors = FALSE, na="", fileEncoding="GBK")
out_file <- paste0("/haplox/users/zhaoys/data/check_vcf/jiefangjun_cfdna_vcf.txt")
cfdna <- NULL
for(i in seq(nrow(csv_df2))){
  for(j in seq(nrow(csv_df))){
    print(csv_df2[i,2])
    if(csv_df2[i,2]==csv_df[j,4]){
      hp_df <- paste0("/haplox/rawout/",csv_df[j,1],"/",csv_df[j,2],"/")
      tmp <- system(paste0("grep ",csv_df2[i,3]," ",hp_df,"*annovar.hg19_multianno.vcf "),intern = T)
      if(length(tmp) == 0){
        result = ""
        output <- cbind(csv_df2[i,],result)
      }
      if(length(tmp) == 1){
        tmp2 <- strsplit(tmp,"\t")[[1]]
        result <- tmp2[length(tmp2)]
        output <- cbind(csv_df2[i,],result)
      }
      cfdna <- rbind(cfdna,output)
      write.table(cfdna,file=out_file, fileEncoding="GBK",row.names=FALSE, na="", quote = F,sep="\t")
    }
  }
}
