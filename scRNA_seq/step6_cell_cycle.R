### Create: zhaoys
### Date: 2019-11-19
### Email: 125588933@qq.com
rm(list = ls()) 
options(stringsAsFactors = F)
load(file = './Rscript/scRNA_seq/input.Rdata')
rawcount_mat[1:4,1:4]
head(df) 


group_list=df$g
plate=df$plate
table(plate)

library(scran)
sce = SingleCellExperiment(list(counts = dat))
#SingleCellExperiment:用于存储单细胞测序数据的单细胞实验类的描述

library(org.Mm.eg.db)
mm.pairs = readRDS(system.file("exdata","mouse_cycle_markers.rds",package='scran'))
##readRDS:将一个R对象(mouse_cycle_markers.rds:小鼠的细胞周期信息（G1,S,G2M分别对应的Ensembl.ID）)写入文件，并恢复它，类似于load,

ensembl = mapIds(org.Mm.eg.db,keys = rownames(sce),keytype = "SYMBOL",column = "ENSEMBL")
##得到小鼠基因数据库的SYMBOL_ID和ENSEMBL_ID的对应列表

assigned <- cyclone(sce,pairs=mm.pairs, gene.names=ensembl)
save(assigned,file = './Rscript/scRNA_seq/step6_cell_cycle_assigned.Rdata')
#计算测到的细胞的细胞周期并保存数据

load('./Rscript/scRNA_seq/step6_cell_cycle_assigned.Rdata')
table(assigned$phases)
# assigned$phases:G1,S,G2M 

draw = cbind(assigned$scores,assigned$phases)
attach(draw)
#attach():数据库连接到R搜索路径,在计算变量时，R会搜索数据库，因此只需给出数据库中的对象的名称就可以访问它们。
library(scatterplot3d)
png('./Rscript/scRNA_seq/cell_cycle_scatterplot3d.png',width = 700,height = 700)
scatterplot3d(G1, S, G2M, angle=19,col.axis="blue", col.grid="lightblue",pch=20,
             color = rainbow(3)[as.numeric(as.factor(assigned$phases))],
              grid=TRUE, box=FALSE,main = '768 Single cell’s cell cycle ')
dev.off()
detach(draw)
png('./Rscript/scRNA_seq/cell_cycle_plot_2D.png')
plot(assigned$scores$G1, assigned$scores$G2M, xlab="G1 score", ylab="G2M score", pch=20)
dev.off()
#如果一个细胞在G1中得分大于0.5，并且它高于G2/M的得分，那么这个细胞就被划分到G1期；
#如果细胞在G2M中得分大于0.5，并且高于G1的得分，那么它就划为G2/M期；
#如果细胞的G1、G2M得分都不大于0.5，那么它就划为S期;可以根据S评分来划分S期，但更可靠的方法是将S期细胞定义为G1和G2M评分低于0.5的细胞。

library(pheatmap)
cg=names(tail(sort(apply(dat,1,sd)),100))
n=t(scale(t(dat[cg,])))
df$cellcycle=assigned$phases
#增加细胞周期信息
ac=df
rownames(ac)=colnames(n)
pheatmap(n,show_colnames =F,show_rownames = F,
         annotation_col=ac,
         filename = './Rscript/scRNA_seq/cell_cycle_heatmap.png')
table(ac[,c(1,5)])
#计算不同细胞周期对应的不同细胞类型的细胞个数



