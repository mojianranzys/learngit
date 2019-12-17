### Create: zhaoys
### Date: 2019-12-09
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
options(warn = -1)
#创建scater要求的对象（必须是matrix）
suppressMessages(library(scater))
sce <- SingleCellExperiment(
  assays = list(counts = as.matrix(counts)),
  colData = meta
)
sce
exprs(sce) <- log2(calculateCPM(sce) + 1)
genes <- rownames(rowData(sce))
genes_ERCC <- genes[grepl("^ERCC-",genes)];length(genes_ERCC)
genes_MT <- genes[grepl("^MT-",genes)];length(genes_MT)  #该表达矩阵无线粒体基因
sce <- calculateQCMetrics(sce,feature_controls = list(ERCC = grep("^ERCC-",genes)))
#过滤
#1.每一个基因的总的counts 大于5
keep_feature <- rowSums(exprs(sce) > 0) >5;table(keep_feature)
sce <- sce[keep_feature,]
tmp <- as.data.frame(rowData(sce))
#2.每一个样本中所有基因的表达量之和大于2000
tf=sce$total_features_by_counts
fivenum(tf)
boxplot(tf)
table(tf > 2000)
sce <- sce[,tf > 2000]

#基因表达
plotExpression(object = sce,rownames(sce)[1:6],x = 'plate',exprs_values = "logcounts")
plotHighestExprs(sce, exprs_values = "counts")
#高表达量基因，top50的基因表达图谱，很多都是ERCC基因，无太大作用
png(file="./Rscript/section02-scRNA/step3_scater_plotExprsFreqVsMean.png",width = 700,height = 700)
plotExprsFreqVsMean(sce)
dev.off()

#PCA降维:线性降维
sce <- runPCA(sce)
reducedDimNames(sce)
head(sce@reducedDims$PCA)
png(file="./Rscript/section02-scRNA/step3_sscater_plotpca.png",width = 700,height = 700)
plotReducedDim(sce, use_dimred = "PCA", 
               shape_by= "plate", 
               colour_by= "g")
dev.off()
##考虑 ERCC 影响后继续PCA
sce2 <- runPCA(sce, 
               feature_set = rowData(sce)$is_feature_control)
png(file="./Rscript/section02-scRNA/step3_scater_drop_ERCC_pca.png",width = 700,height = 700)
plotReducedDim(sce2, use_dimred = "PCA", 
               shape_by= "plate", 
               colour_by= "g")
dev.off()

#tSNE降维:非线性降维
sce <- runTSNE(sce,perplexity = 10)
plotTSNE(object = sce,               
         shape_by= "plate", 
         colour_by= "g")
#对tSNE降维的结果进行不同的聚类
#kmeans聚类
colData(sce)$tSNE_kmeans <- as.character(kmeans(sce@reducedDims$TSNE,centers = 4)$clust)
head(sce@reducedDims$TSNE)
#层次聚类
hc=hclust(dist(sce@reducedDims$TSNE))
clus = cutree(hc,4)
colData(sce)$tSNE_hc <- as.character(clus)
png(file="./Rscript/section02-scRNA/step3_scater_tSNE_kmeans.png",width = 700,height = 700)
plotTSNE(sce,  colour_by = "tSNE_kmeans")
dev.off()
png(file="./Rscript/section02-scRNA/step3_scater_SNE_hclust.png",width = 700,height = 700)
plotTSNE(sce,  colour_by = "tSNE_hc")
dev.off()
#DiffusionMap降维:非线性降维
sce <- runDiffusionMap(sce)
png(file="./Rscript/section02-scRNA/step3_scater_diffusionap_plot.png",width = 700,height = 700)
plotDiffusionMap(sce,  
                 shape_by= "plate", 
                 colour_by= "g")
dev.off()
#SC3(single cell Consensus Clustering):一个无监督聚类和分析scRNA-Seq数据的工具，不提供QC和normalisaiton功能
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
if(!require("SC3")){
  BiocManager::install("SC3")
}
#browseVignettes("SC3") #查看SC3的说明,主要步骤如下：
#1.Setting SC3 parameters...
#2.sc3_calc_dists(distances)：分别用Euclidean, Pearson and Spearman metrics构建距离矩阵。实验发现dropout对距离的计算没有影响。（1x3个矩阵）
#3.sc3_calc_transfs(transformations)：分别用PCA和graph Laplacian进行transformation，并按特征值升序排序。（3x2个矩阵）
#4.sc3_kmeans(k-means)：对前d个特向量进行k-means聚类。
#5.sc3_calc_consens(consensus)：用the cluster-based similarity partitioning algorithm (CSPA)计算consensus矩阵。每个聚类结果，生成binary相似矩阵，两个cell属于相同簇则相似性为1，否则为0。平均所有的相似性矩阵作为consensus matrix。consensus matrix用hierarchical clustering进行聚类。
#6.Calculating biology...
library(SC3)
sce <- sc3_estimate_k(sce)
#估计K值
metadata(sce)$sc3$k_estimation  #预估值k=10
rowData(sce)$feature_symbol=rownames(rowData(sce))
#设置
kn=4
sc3_cluster="sc3_4_clusters"
sce <- sc3(object = sce,ks=kn,biology = TRUE)

sc3_plot_consensus(sce,k=kn,show_pdata = c("g",sc3_cluster))

sc3_plot_expression(sce,k=kn,show_pdata = c("g",sc3_cluster))

sc3_plot_markers(sce,k=kn,show_pdata =  c("g",sc3_cluster))

sc3_plot_de_genes(sce, k=kn,show_pdata =  c("g",sc3_cluster))

png(file="./Rscript/section02-scRNA/step3_scater_sc3_silhouette_plot.png",width = 700,height = 700)
sc3_plot_silhouette(sce, k=kn)
dev.off()
plotPCA(sce, shape_by= "g" , colour_by =  sc3_cluster )














