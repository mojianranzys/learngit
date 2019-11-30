## 
### ---------------
###
### Create: zhao yingshen
### Date: 2019-10-31
### Email: 1255886933@qq.com

Sys.setenv(R_MAX_NUM_DLLS=999)#R的namespace是有上限的，如果导入包时超过这个上次就会报错,R_MAX_NUM_DLLS可以修改上限
options(stringsAsFactors = F) #options:允许用户对工作空间进行全局设置，防止R自动把字符串string的列辨认成factor

options()$repos  ## 查看使用install.packages安装时的默认镜像,一般为RStudion
options()$BioC_mirror ##查看使用bioconductor的默认镜像
options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc/") ##指定镜像，这个是中国科技大学镜像
options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))##指定install.packages安装镜像，这个是清华镜像

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager") 
}
library(BiocManager)
if(F){
BiocManager::install(c( 'scran'),ask = F,update = F)
BiocManager::install("TxDb.Mmusculus.UCSC.mm10.knownGene",ask = F,update = F)
BiocManager::install("org.Mm.eg.db",ask = F,update = F)
BiocManager::install("genefu",ask = F,update = F)
BiocManager::install("org.Hs.eg.db",ask = F,update = F)
BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene",ask = F,update = F)
install.packages("ggfortify")
install.packages("FactoMineR")
install.packages("factoextra")
}

rm(list=ls())

#读取表达矩阵
rawcount_mat <- read.table("./Rscript/scRNA_seq/GSE111229_Mammary_Tumor_fibroblasts_768samples_rawCounts.txt", header = T ,sep = '\t')
rawcount_mat[1:6,1:4]
dat <- rawcount_mat[apply(rawcount_mat, 1, function(x) sum(x > 1) > floor(ncol(rawcount_mat)/50)),]
#row:genes &  col:cells
table(apply(rawcount_mat, 1, function(x) sum(x > 1) > floor(ncol(rawcount_mat)/50)))
#符合该条件的行(基因)的细胞表达量才算合格(%2的细胞有表达量才算合格)
#apply(X, MARGIN, FUN, ...):MARGIN的值是c(1, 2)，1表示row, 2表示col
#floor():四舍五入取整数
dat[1:4,1:4]

dat <- log2(edgeR::cpm(dat)+1)
#归一化的一种方式，CPM(count-per-million，每百万碱基中每个转录本的count值,即：某基因在某细胞中的表达值占该细胞总文库的比例，再乘以100万）
#用degeR来计算cpm，目的是为了去除文库的大小差异

#层次聚类
hc = hclust(dist(t(dat)))
#dist:计算行与行之间的距离，因为要计算细胞(列)之间的距离，所以要进行转置t(),默认是"euclidean"(欧几里得)
#cor:计算列与列之间的相关性
#scale:默认对每一个样本(列)内部归一化
plot(hc)
#plot画的图可以简单的看出来分成了4类细胞
clus = cutree(hc,4)
#cutree:对hclust()函数的聚类结果进行剪枝，即选择输出指定类别数的系谱聚类结果
group_list = as.factor(clus)
table(group_list)#统计每一类中的细胞数

#提取批次信息
library(stringr)
plate = str_split(colnames(dat),"_",simplify = T)[,3] 
#实验板
n_g = apply(rawcount_mat, 2 , function(x) sum(x>1))
#定义，reads数量大于1的那些基因为有表达，一般而言，单细胞转录组过半数的基因是不会表达的
df=data.frame(g=group_list,plate = plate, n_g = n_g)
df$all = "all"
save(rawcount_mat,dat,df,file="./Rscript/scRNA_seq/input.Rdata")



###2.因为文章是用RPKM的表达矩阵(对rawcount做了归一化(normalization))做的分析 所以需要重新分析结果
#RPKM是代表每百万reads中来自于某基因每千碱基长度的reads数
#RPKM是将map到基因的read数除以(map到基因组上的所有read数(以million为单位)与RNA的长度(以KB为单位)的乘积),即RPKM=total exon reads / (mapped reads(millons)*exon length(KB)
rawcount_mat <- read.table("./Rscript/scRNA_seq/GSE111229_Mammary_Tumor_fibroblasts_768samples_rpkmNormalized.txt", header = T ,sep = '\t')
rawcount_mat[1:6,1:4]
dat <- rawcount_mat[apply(rawcount_mat, 1, function(x) sum(x > 0) > floor(ncol(rawcount_mat)/50)),]
#RPKM的表达矩阵，x的值大于0就行
table(apply(rawcount_mat, 1, function(x) sum(x > 0) > floor(ncol(rawcount_mat)/50)))
dat[1:4,1:4]
#层次聚类
hc = hclust(dist(t(dat)))
plot(hc)
#plot画的图可以简单的看出来分成了4类细胞
clus = cutree(hc,4)
group_list = as.factor(clus)
table(group_list)#统计每一类中的细胞数

#提取批次信息
library(stringr)
plate = str_split(colnames(dat),"_",simplify = T)[,3] 
#实验板
n_g = apply(rawcount_mat, 2 , function(x) sum(x>1))
#定义，reads数量大于1的那些基因为有表达，一般而言，单细胞转录组过半数的基因是不会表达的
df=data.frame(g=group_list,plate = plate, n_g = n_g)
df$all = "all"
save(rawcount_mat,dat,df,file="./Rscript/scRNA_seq/input_rpkm.Rdata")


  