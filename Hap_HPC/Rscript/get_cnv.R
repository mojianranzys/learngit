    library(dplyr)
    args <- commandArgs(TRUE)
    cnv_csv <- args[1]
    in_cnv <- args[2]
    out_cnv <- args[3]
#    genes <- read.csv("cnv.csv", header=FALSE,stringsAsFactors=FALSE)
    genes <- read.csv(cnv_csv, header=FALSE,stringsAsFactors=FALSE)
    genes <- genes[genes != ""]
    genes <- gsub("\\s+", "", genes)
    cnv <- read.table(in_cnv, header=TRUE, sep="\t", stringsAsFactors = FALSE)
    cnv_genes <- NULL
    cnv_values <- NULL
    chr_values <- NULL
    for(i in seq(nrow(cnv))){
        tmp <- unlist(strsplit(cnv[i,2],","))
        tmp_num <- rep(round(2*2^cnv[i,3],1), length(tmp))
        cnv_genes <- c(cnv_genes, tmp)
        cnv_values <- c(cnv_values, tmp_num)
        chr_values <- c(chr_values, rep(cnv[i, 1], length(tmp)))
    }
    res <- data.frame(genes=cnv_genes, cnv=cnv_values, chrs=chr_values)
    res_last <- res[as.character(res[,1]) %in% genes,]
    res_last <- res_last[order(res_last[,1]),]

    myUnique <- function(para_df){
      dups <- anyDuplicated(para_df$genes)
      while (dups != 0){
            target <- which(para_df$genes == para_df$genes[dups])
            if (para_df$cnv[target[1]] >= para_df$cnv[dups]){
                    para_df <- para_df[-dups, ]
            } else {
                    para_df <- para_df[-target, ]
                }
            dups <- anyDuplicated(para_df$genes)
        }
      return(para_df)
    }

    res_last_remove<- res_last %>% group_by(genes) %>% filter(cnv==max(cnv)) %>% distinct(genes, .keep_all = TRUE)
#    write.csv(res_last, file="S004_20170925013-9_cfdna_hap-research-0317_4849_rg_cnv_result.csv", row.names=FALSE)
    write.csv(res_last_remove, file=out_cnv, row.names=FALSE, quote = FALSE)
