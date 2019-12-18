### Create: zhaoys
### Date: 2019-12-18
### Email: 125588933@qq.com
#Monocle:能够将细胞按照模拟的时间顺序进行排列，显示它们的发展轨迹如细胞分化等生物学过程。
rm(list = ls()) 
options(stringsAsFactors = F)
library(stringr)
load(file = './Rscript/scRNA_seq/input.Rdata')
counts = rawcount_mat
counts[1:4,1:4];dim(counts)
meta=df
table(meta$g)
fivenum(apply(counts,1,function(x) sum(x>0) ))
#fivenum：Returns Tukey's five number summary (minimum, lower-hinge, median, upper-hinge, maximum) for the input data.
boxplot(apply(counts,1,function(x) sum(x>0) ))
fivenum(apply(counts,2,function(x) sum(x>0) ))
hist(apply(counts,2,function(x) sum(x>0) ))
#1.创建monocle对象
suppressMessages(library(monocle))
gene_ann <- data.frame(
  gene_short_name = row.names(counts),
  row.names = row.names(counts)
)
head(gene_ann)
sample_ann <- meta
pd <- new("AnnotatedDataFrame",
          data=sample_ann)
fd <- new("AnnotatedDataFrame",
          data=gene_ann)
#new:生成一个类(class)的对象
sc_cds <- newCellDataSet(
  cellData = as.matrix(counts),
  phenoData = pd,
  featureData = fd,
  expressionFamily = negbinomial.size(),
  lowerDetectionLimit = 1
)
sc_cds

#2.质控过滤
cds=sc_cds
cds   #24582 features, 768 samples
cds <- detectGenes(cds,min_expr = 0.1)
#-------过滤基因------
print(head(fData(cds)))
expressed_genes <- row.names(subset(fData(cds),num_cells_expressed >= 5))
cds <- cds[expressed_genes,]
cds   #14442 features, 768 samples 
#需要去除ERCC基因
is.ERCC <- grepl("^ERCC-",expressed_genes)
cds <- cds[expressed_genes[!is.ERCC],]
cds   #14362 features, 768 samples ，过滤掉80个ERCC基因
#-------过滤细胞-----
print(head(pData(cds)))
valid_cells <- row.names(subset(pData(cds),num_genes_expressed > 2000))
cds <- cds[,valid_cells]
cds   #14362 features, 693 samples 

#3.归一化
library(dplyr)
colnames(phenoData(cds)@data)
cds <- estimateSizeFactors(cds)
#Size factors help us normalize for differences in mRNA recovered across cells,
cds <- estimateDispersions(cds)
# "dispersion" values will help us perform differential expression analysis later

#4.聚类降维
disp_table <- dispersionTable(cds)
head(disp_table)
unsup_clustering_genes <- subset(disp_table,mean_expression >= 0.1)
cds <- setOrderingFilter(cds,unsup_clustering_genes$gene_id)
cds
#setOrderingFilter:该函数标记将在后续调用clustercell时用于集群化的基因
png(file="./Rscript/section02-scRNA/step4_monocle_cds_ordering_genes_plot.png",width = 700,height = 700)
plot_ordering_genes(cds)
dev.off()
#图中黑色的点就是被标记出来要进行聚类的点
png(file="./Rscript/section02-scRNA/step4_monocle_cds_variance_explained_plot.png",width = 700,height = 700)
plot_pc_variance_explained(cds,return_all = F)
dev.off()

#----进行降维----
cds <- reduceDimension(cds,max_components = 2,reduction_method = 'tSNE',residualModelFormulaStr = "~num_genes_expressed",verbose = T)
##residualModelFormulaStr:指定在聚类之前要从数据中减去的效果，本次去除检测到的基因数量的效应,也可以不设置该参数
#----进行聚类----
cds <- clusterCells(cds,num_clusters = 5)
#Distance cutoff calculated to 1.610852
png(file="./Rscript/section02-scRNA/step4_monocle_cds_cell_cluster_plot.png",width = 700,height = 700)
plot_cell_clusters(cds, 1, 2, color = "Cluster")
dev.off()
#层次聚类结果
png(file="./Rscript/section02-scRNA/step4_monocle_cds_cell_g_plot.png",width = 700,height = 700)
plot_cell_clusters(cds, 1, 2, color = "g")
dev.off()
table(pData(cds)$Cluster,pData(cds)$g)
#结果差异较大
png(file="./Rscript/section02-scRNA/step4_monocle_cds_cluster_boxplot.png",width = 700,height = 700)
boxplot(pData(cds)$num_genes_expressed~pData(cds)$Cluster)
dev.off()
png(file="./Rscript/section02-scRNA/step4_monocle_cds_g_boxplot.png",width = 700,height = 700)
boxplot(pData(cds)$num_genes_expressed~pData(cds)$g)
dev.off()

#5.找差异基因
start=Sys.time()
diff_test_res <- differentialGeneTest(cds,fullModelFormulaStr = "~Cluster")
head(diff_test_res)
end=Sys.time()
end-start
#选择矫正后的p值（即:q值）<10%的基因作为差异基因
sig_genes <- subset(diff_test_res,qval < 0.1)
dim(sig_genes)
head(sig_genes)

#6.推断发育轨迹
#step1.选取差异显著的基因列表
ordering_genes <-  row.names(subset(sig_genes))
cds <- setOrderingFilter(cds,ordering_genes)
plot_ordering_genes(cds)

#step2.降维
cds <- reduceDimension(cds, max_components = 2,
                       method = 'DDRTree')
#降维有很多种方法, 不同方法的最后展示的图都不太一样

#step3.对细胞进行排序
cds <- orderCells(cds)

#step4.可视化函数 
#发育轨迹
png(file="./Rscript/section02-scRNA/step4_monocle_cds_cell_trajectory_plot.png",width = 700,height = 700)
plot_cell_trajectory(cds, color_by = "Cluster")
dev.off()
#可以很明显看到细胞的发育轨迹

#展现marker基因在发育轨迹推断的效果，本例子随便选取了6个差异表达基因。
png(file="./Rscript/section02-scRNA/step4_monocle_cds_gene_pseudotime_plot.png",width = 700,height = 700)
plot_genes_in_pseudotime(cds[head(sig_genes$gene_short_name),], 
                         color_by = "Cluster")
dev.off()













