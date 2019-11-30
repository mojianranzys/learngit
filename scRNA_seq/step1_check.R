### Create: zhaoys
### Date: 2019-11-06 
### Email: 125588933@qq.com
rm(list = ls()) 
options(stringsAsFactors = F)
load(file = './Rscript/scRNA_seq/input_rpkm.Rdata')
dat[1:4,1:4]
head(df)
group_list <- df$g   ##取出层次聚类信息
table(group_list)
cg = names(tail(sort(apply(dat, 1, sd)),100)) ##取标准差最大的100行的行名(基因)

##针对前100名的sd的基因集的表达矩阵
library(pheatmap)
mat=log2(dat[cg,]+0.01)
pheatmap(mat,show_colnames =F,show_rownames = F,
         filename = "./Rscript/scRNA_seq/all_cells_top_100_sd_rpkm.png")

##归一化，分组画图
n=t(scale(t(mat)))
n[n>2]=2 ##设置了一个上限
n[n< -2]=-2 ##设置了一个下限
n[1:4,1:4]
ac=data.frame(g=group_list) #制作细胞（样本）分组矩阵
rownames(ac)=colnames(n) ##ac(细胞分类信息)的行名（样本名）等于n的列名（样本名）
pheatmap(n,show_colnames =F,
         show_rownames = F,
         annotation_col=ac,
         filename = "./Rscript/scRNA_seq/all_cells_top_100_sd_cutree1_rpkm.png")


##重新聚类并且分组
hc=hclust(dist(t(n))) 
clus = cutree(hc, 4)
group_list=as.factor(clus)
table(group_list)
table(group_list,df$g) ## 其中 df$g 是前面步骤针对全部表达矩阵的层次聚类结果。
ac=data.frame(g=group_list)
rownames(ac)=colnames(n)
pheatmap(n,show_colnames =F,show_rownames = F,
         annotation_col=ac,
         filename = './Rscript/scRNA_seq/all_cells_top_100_sd_cutree_2_rpkm.png')


##PCA(主成分分析)
dat_back=dat
dat=dat_back
dat[1:4,1:4]
dat=t(dat)
dat=as.data.frame(dat)
dat=cbind(dat,group_list)
dat[1:4,12197:12199]
dat[,ncol(dat)] #ncol()列，返回列长值
table(dat$group_list)
library("FactoMineR")
library("factoextra") 
dat.pca <- PCA(dat[,-ncol(dat)], graph = FALSE) #'-'表示“非”
fviz_pca_ind(dat.pca,repel =T,
             geom.ind = "point", # show points only (nbut not "text")只显示点不显示文本
             col.ind = dat$group_list, # color by groups 颜色组
             addEllipses = TRUE, # Concentration ellipses 集中成椭圆
             legend.title = "Groups")
ggsave('./Rscript/scRNA_seq/all_cells_PCA_rpkm.png')
