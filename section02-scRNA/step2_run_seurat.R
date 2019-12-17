### Create: zhaoys
### Date: 2019-12-04
### Email: 125588933@qq.com
rm(list = ls()) 
options(stringsAsFactors = F)
load(file = './Rscript/scRNA_seq/input.Rdata')
rawcount_mat[1:4,1:4]
counts=rawcount_mat
dim(counts)
library(stringr)
meta=df
head(meta)
gs=read.table('./Rscript/section02-scRNA/top18-genes-in-4-subgroup.txt')[,1]
gs=rev(gs)

library(pheatmap)
fivenum(apply(counts,1,function(x) sum(x>0) ))
png(file="./Rscript/section02-scRNA/step2_genes_expression_boxplot.png",width = 700,height = 700)
boxplot(apply(counts,1,function(x) sum(x>0) )) #检查有表达的基因
dev.off()
fivenum(apply(counts,2,function(x) sum(x>0) ))
png(file="./Rscript/section02-scRNA/step2_cells_expression_hist.png",width = 700,height = 700)
hist(apply(counts,2,function(x) sum(x>0) )) #检查有表达的细胞 
dev.off()
##run seurat
library(Seurat)
#构建 seurat 需要的对象，其中 min.cells 和 min.features 两个参数是经验值
sce <- CreateSeuratObject(raw.data = counts, 
                          meta.data =meta,
                          min.cells = 5, #基因至少在min.cells个细胞中表达
                          min.genes = 2000, #每个细胞至少表达min.genes个基因
                          project = "sce")
sce@data[1:4,1:4]
table(apply(counts,2,function(x) sum(x>0) )>2000)
table(apply(counts,1,function(x) sum(x>0) )>4)
head(sce@raw.data) #raw.data存放的是每个cell中每个gene的原始UMI数据
head(sce@data) #data存放的是gene的表达量
head(sce@meta.data) #meta.data存放的是每个细胞的统计数据如UMI数目，gene数目等，orig.ident此时存放的是project信息。
dim(sce@data)

library(ggplot2)
if(F){
#提取线粒体基因列表,该单细胞列表中不含线粒体基因(^MT-)
mito.genes <- grep(
  pattern = "^MT-",
  x = rownames(x = sce@data),
  value = TRUE)
# 统计线粒体基因丰度的百分比
percent.mito <- Matrix::colSums(sce@raw.data[mito.genes, ]) / Matrix::colSums(sce@raw.data)
# 将统计的百分比数据添加对象中
sce <- AddMetaData(
  object = sce,
  metadata = percent.mito,
  col.name = "percent.mito")
# 小提琴图
VlnPlot(
  object = sce,
  features.plot = c("nGene", "nUMI", "percent.mito"),
  group.by = 'plate',
  nCol = 3)
}
#nGene代表的是在该细胞中共检测到的表达量大于0的基因个数
#nUMI代表的是该细胞中所有基因的表达量之和
#mito.percent代表的是线粒体基因表达量的百分比,该单细胞列表中不含线粒体基因(^MT-)
png(file="./Rscript/section02-scRNA/step2_seurat_plate_vlnplot.png",width = 700,height = 700)
VlnPlot(object = sce, 
        features.plot = c("nGene", "nUMI" ),
        group.by = 'plate',
        nCol = 2)
#以plate(实验板)分类
dev.off()
png(file="./Rscript/section02-scRNA/step2_seurat_g_vlnplot.png",width = 700,height = 700)
VlnPlot(object = sce, 
        features.plot = c("nGene", "nUMI" ),
        group.by = 'g',
        nCol = 2)
#以g(细胞类型)分类
dev.off()

#关于ERCC spik-in:spike-in是已知浓度的外源RNA分子。在单细胞裂解液中加入spike-in后，再进行反转录。
#最广泛使用的spike-in是由External RNA Control Consortium （ERCC）提供的,目前使用的赛默飞公司提供的ERCC是包括92个不同长度和GC含量的细菌RNA序列.
#ERCC应该在样本解离后、建库前完成添加,高的ERCC含量与低质量数据相关，并且通常是排除的标准。
ercc.genes <- grep(pattern = "^ERCC-",
                   x = row.names(x=sce@data),
                   value = TRUE)
# 统计ERCC丰度的百分比
percent.ercc <- Matrix::colSums(sce@raw.data[ercc.genes, ]) / Matrix::colSums(sce@raw.data)
# 将统计的百分比数据添加对象中
sce <- AddMetaData(
  object = sce,
  metadata = percent.ercc,
  col.name = "percent.ercc")
# 小提琴图
png(file="./Rscript/section02-scRNA/step2_seurat_g_add_ercc_vlnplot.png",width = 700,height = 700)
VlnPlot(
  object = sce,
  features.plot = c("nGene", "nUMI", "percent.ercc"),
  group.by = 'g',
  nCol = 3)
dev.off()
#结论：细胞能检测到的基因数量与其含有的ERCC序列成反比
VlnPlot(sce,group.by = 'plate',c("Gapdh","Bmp3","Brca1","Brca2","nGene"))
#批次效应
GenePlot(object = sce,  gene1 = "nUMI", gene2 = "nGene")
GenePlot(object = sce,  gene1 = "Brca1", gene2 = "Brca2")
#基因的相关性
CellPlot(sce,sce@cell.names[3], 
         sce@cell.names[4],
         do.ident = FALSE)
#细胞的相关性
#对每个基因进行标准化：该基因的UMI除以该细胞内转录物的总UMI并乘以10000，
#然后在使用log1p对这些值进行自然对数转换
sce <- NormalizeData(object = sce,
                     normalization.method = "LogNormalize",
                     scale.factor = 10000,
                     display.progress = TRUE)
sce@data[1:4,1:4]
library(pheatmap)
pheatmap(as.matrix(sce@data[gs,]))

#识别可变基因(高度变化的基因)，同时控制变异与平均表达之间的强烈关系。'
png(file="./Rscript/section02-scRNA/step2_seurat_findvarablegenes.png",width = 700,height = 700,res = 72)
sce <- FindVariableGenes(object = sce,
                         mean.function = ExpMean, #计算平均表达
                         dispersion.function = LogVMR) #计算离散度
dev.off()
head(sce@var.genes)
#线性回归分析,中心化和比例化，去除不想要的变异源,比如ERCC
#中心化：首先计算基因A在所有细胞中的平均表达量，然后分别将每个细胞中基因A的表达值减去平均值。
#比例化：在中心化的基础上，首先计算基因A在所有细胞中的中心化值后的标准差，然后分别将每个细胞中基因A的中心化值除以标准差
sce <- ScaleData(object = sce, 
                 vars.to.regress = c("nUMI","nGene","percent.ercc"))
head(sce@scale.data[1:4,1:4])

#PCA线性降维
sce <- RunPCA(object = sce,pc.genes = sce@var.genes,do.print = TRUE,pcs.print = 1:5,genes.print = 5,pcs.compute = 20)
head(sce@dr$pca@gene.loadings)
tmp <- sce@dr$pca@gene.loadings
png(file="./Rscript/section02-scRNA/step2_seurat_sce_vizpca.png",width = 1000,height = 1000,res = 72)
VizPCA( sce, pcs.use = 1:20)
dev.off()
png(file="./Rscript/section02-scRNA/step2_seurat_sce_plate_pca.png",width = 700,height = 700,res = 72)
PCAPlot(sce, 
        dim.1 = 1,
        dim.2 = 2,
        group.by = 'plate',
        pt.size = 1.7,
        plot.title='Seurat pca by plate')
dev.off()
png(file="./Rscript/section02-scRNA/step2_seurat_sce_g_pca.png",width = 700,height = 700,res = 72)
PCAPlot(sce, 
        dim.1 = 1, 
        dim.2 = 2,
        group.by = 'g',
        pt.size = 1.7,
        plot.title='Seurat pca by cell type')
dev.off()
sce <- ProjectPCA(object = sce,do.print =F)
PCHeatmap(object = sce, 
          pc.use = 1, 
          cells.use = 100, 
          do.balanced = TRUE,
          label.columns = FALSE)
png(file="./Rscript/section02-scRNA/step2_seurat_sce_PCA_pcheatmap.png",width = 1000,height = 1000,res = 72)
PCHeatmap(object = sce, 
          pc.use = 1:20, 
          cells.use = 100, 
          do.balanced = TRUE, 
          label.columns = FALSE)
dev.off()
#聚类分析
sce1<- FindClusters(object = sce,
                        reduction.type = "pca",
                        dims.use = 1:20,
                        force.recalc = T,
                        resolution = 0.4,
                        print.output = 0,
                        save.SNN = TRUE)
PrintFindClustersParams(sce1)
table(sce1@meta.data$res.0.4) 
#resolution 是最关键的参数,细胞类型分为0,1,2,3对应的1,2,3,4
#tSNE非线性降维
sce = sce1
sce <- RunTSNE(object = sce,
               dims.use = 1:10,
               do.fast=TRUE,
               do.label=T)
png(file="./Rscript/section02-scRNA/step2_seurat_sce_res.0.4_tSNE.png",width = 1000,height = 1000,res = 72)
TSNEPlot(object = sce)
dev.off()

#对每个类别细胞都找到自己的marker基因
sce.markers <- FindAllMarkers(sce, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
#only.pos 参数，可以指定返回positive markers 基因
head(sce.markers)
library("dplyr")
top18 <- sce.markers %>% group_by(cluster) %>% top_n(n = 18, wt = avg_logFC)
#验证计算出来top18 marker基因与paper中给的top18的一致性
same_makers <- top18[top18$gene %in% gs,]
#intersect(top18$gene,gs)
table(same_makers$cluster)
png(file="./Rscript/section02-scRNA/step2_seurat_sce_top18_markers.png",width = 1000,height = 1000,res = 72)
DoHeatmap(sce,genes.use = top18$gene,slim.col.label = T,remove.key = TRUE)
dev.off()

#ident.1：设置寻找marker的对象,ident.1=c(0,1,2,3)对应的cell=c(1,2,3,4)
markers_1 <- FindMarkers(object = sce,ident.1 = 0,min.pct = 0.25)
print(x = head(markers_1))
markers_1_top10 =  rownames(head(x = markers_df, n = 10))
# 可视化最后找到的marker基因
png(file="./Rscript/section02-scRNA/step2_seurat_sce_markers_1_top10_VlnPlot.png",width = 1000,height = 1000,res = 72)
VlnPlot(object = sce, features.plot =markers_1_top10, 
        use.raw = TRUE, y.log = TRUE)
dev.off()
# 首先可视化找到的marker基因
FeaturePlot(object = sce, 
            features.plot =markers_1_top10,
            cols.use = c("grey", "blue"), 
            reduction.use = "tsne")

# 然后可视化文献作者给出的基因
#cell_1:gs[1:18]
png(file="./Rscript/section02-scRNA/step2_seurat_sce_tSNE_cell_1_gs.png",width = 1000,height = 1000)
FeaturePlot(object = sce, 
            features.plot =gs[1:18], 
            cols.use = c("grey", "blue"), 
            reduction.use = "tsne")
dev.off()
#cell_2:gs[19:36]
png(file="./Rscript/section02-scRNA/step2_seurat_sce_tSNE_cell_2_gs.png",width = 1000,height = 1000)
FeaturePlot(object = sce, 
            features.plot =gs[19:36], 
            cols.use = c("grey", "blue"), 
            reduction.use = "tsne")
dev.off()
#cell_3:gs[37:54]
png(file="./Rscript/section02-scRNA/step2_seurat_sce_tSNE_cell_3_gs.png",width = 1000,height = 1000)
FeaturePlot(object = sce, 
            features.plot =gs[37:54], 
            cols.use = c("grey", "blue"), 
            reduction.use = "tsne")
dev.off()
#cell_4:gs[55:72]
png(file="./Rscript/section02-scRNA/step2_seurat_sce_tSNE_cell_4_gs.png",width = 1000,height = 1000)
FeaturePlot(object = sce, 
            features.plot =gs[55:72], 
            cols.use = c("grey", "blue"),
            reduction.use = "tsne")
dev.off()







