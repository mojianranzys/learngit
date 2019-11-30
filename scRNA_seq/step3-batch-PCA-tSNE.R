### Create: zhaoys
### Date: 2019-11-13
### Email: 125588933@qq.com
##批次效应---PCA and tSNE

rm(list = ls()) 
options(stringsAsFactors = F)
load(file = './Rscript/scRNA_seq/input_rpkm.Rdata')
group_list=df$g
plate=df$plate
table(plate)
dat=t(dat)
dat=as.data.frame(dat)
dat[1:4,1:4]
dat=cbind(dat,plate)
table(dat$plate)

#两种降维方法，分析批次效应
#PCA和tSNE的算法具有一定的随机性，所以绘制的图每次都不一样，但是可以看出是否有批次效应

#PCA
library("FactoMineR")
library("factoextra") 
dat.pca <- PCA(dat[,-ncol(dat)], graph = FALSE)
fviz_pca_ind(dat.pca,#repel =T,
             geom.ind = "point", # show points only (nbut not "text")
             col.ind = dat$plate, # color by groups
             addEllipses = TRUE, # Concentration ellipses
             legend.title = "Groups",
) 
ggsave('./Rscript/scRNA_seq/two_plate_pca_rpkm.png')

#tSNE
library(Rtsne) 
load(file = './Rscript/scRNA_seq/input_rpkm.Rdata')
dat_matrix <- t(dat)
dat_matrix =log2(dat_matrix+0.01)
tsne_out <- Rtsne(dat_matrix,pca=FALSE,perplexity=30,theta=0.0)
# tsne_out$Y:降维之后的二维空间对应的数据点
head(tsne_out$Y)

png('./Rscript/scRNA_seq/two_plate_tsne_plot_rpkm.png',width = 800, height = 800)
plot(tsne_out$Y,xlab = "tSNE1", ylab = "tSNE2",col= plate,type = 'p',pch = 19)
dev.off()

library(ggpubr)
tsne_df=as.data.frame(tsne_out$Y)
colnames(tsne_df) = c("tSNE1", "tSNE2")
tsne_df$plate = plate
head(tsne_df)
ggscatter(tsne_df, x = 'tSNE1', y = 'tSNE2', color = "plate", point = T, size = 1.5)
ggsave('./Rscript/scRNA_seq/two_plate_ggscatter_rpkm.png')









