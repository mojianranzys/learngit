### Create: zhaoys
### Date: 2019-12-04 
### Email: 125588933@qq.com
### 重复文献中的那张热图
rm(list = ls()) 
options(stringsAsFactors = F)
load(file = './Rscript/scRNA_seq/input_rpkm.Rdata')
counts = rawcount_mat
counts[1:4,1:4];dim(counts)
dat[1:4,1:4];dim(dat)
dat=log2(dat+1)
meta=df
head(meta) 
library(stringr)
gs=read.table('./Rscript/section02-scRNA/top18-genes-in-4-subgroup.txt')[,1]
gs=rev(gs)
library(pheatmap)
pheatmap(dat[gs,])
pheatmap(dat[gs,],cluster_rows = F)
table(meta$g)
tmp=data.frame(g=meta$g)
rownames(tmp)=colnames(dat)#生成细胞与细胞类型的对应列表
png(file='./Rscript/section02-scRNA/step1_top18_genes_pheatmap.png',width = 700,height = 700)
pheatmap(dat[gs,],annotation_col = tmp,cluster_rows = F,cluster_cols = T,show_colnames =F,main = "top18-genes-pheatmap")
dev.off()
