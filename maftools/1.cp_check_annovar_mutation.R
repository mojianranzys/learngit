library(stringr)
csv <- paste0("/haplox/users/zhaoys/Data/HPCH2018002_09/WESPlus_need_information.csv")
csv_df <- read.csv(csv, header=TRUE, stringsAsFactors = FALSE, na="", fileEncoding="GBK")
for(i in seq(nrow(csv_df))){
  system(paste0("rsync -avzhetopg --progress --rsh=ssh /haplox/rawout/",csv_df[i,1],"/ffpedna_vs_gdna/",csv_df[i,2],"/*annovar.hg19_multianno.txt /haplox/users/zhaoys/Data/HPCH2018002_09/maftools/annova_txt/"))
  system(paste0("rsync -avzhetopg --progress --rsh=ssh /x01_haplox/rawout/",csv_df[i,1],"/ffpedna_vs_gdna/",csv_df[i,2],"/*annovar.hg19_multianno.txt /haplox/users/zhaoys/Data/HPCH2018002_09/maftools/annova_txt/"))
  #   system(paste0("ls /haplox/users/zhaoys/Data/HPCH2018002_09/HPCH2018002_09_vcf/",csv_df[i,2],"*vcf"))
  #   system(paste0("ls /haplox/users/zhaoys/Data/HPCH2018002_09/HPCH2018002_09_mutation/Curl_mrbam*",csv_df[i,3],"_",csv_df[i,23],"*csv"))
}
