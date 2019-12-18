args <- commandArgs(TRUE)
input <- args[1]
time <- substr(input, 3,6)
name <- c("huang","lm","wenting","yb","fm","zys","ZHX")
cat("----------------Clinical Report------------\n")
for(i in seq(length(name))){
  dir <- paste0("/x01_haplox/hapreports/4.working/",time,"*/",name[i],"/*.docx")
  file <- system(paste0("ls -l ",dir),inter = T)
  num <- length(file)
  cat(name[i],":",num,"\n")
}
cat("----------------HPCH Report------------\n")
for(i in seq(length(name))){
  dir <- paste0("/x01_haplox/hapreports/12.zszl_crc_chemo_2018/待审核/",time,"*/",name[i],"/*.docx")
  file <- system(paste0("ls -l ",dir),inter = T)
  num <- length(file)
  cat(name[i],":",num,"\n")
}

