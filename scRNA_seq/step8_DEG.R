### Create: zhaoys
### Date: 2019-11-25 
### #Email: 125588933@qq.com
##仅仅为测试
rm(list = ls())
options(stringsAsFactors = F)
load(file = "./Rscript/scRNA_seq/input.Rdata")
head(df)
table(df$g)
# 注意:变量rawcount_mat是原始的counts矩阵，变量dat是logCPM后的表达量矩阵
experSet = rawcount_mat[apply(rawcount_mat,1,function(x) sum(x>1) > floor(ncol(rawcount_mat)/50)),]
experSet = experSet[!grepl("ERCC",rownames(experSet)),]
# 去除ERCC这个基因（在每一种细胞类型中都高表达）

group_list = ifelse(df$g == 1,"Me","Other") 
table(group_list)
# 细胞类型1("Me")和其他细胞类型2,3,4("Other")做比对
library(edgeR)
#edgeR是一个用于分析SAGE、CAGE、Tag-seq或RNA-seq等RNA测序技术产生的数字基因表达数据的软件包，其重点是检测差异表达
if(T){
do_limma_RNAseq <- function(experSet,group_list){
  suppressMessages(library(limma))
  design <- model.matrix(~0+factor(group_list))
  colnames(design) = levels(factor(group_list)) 
  rownames(design)=colnames(experSet)
  dge <- DGEList(counts = experSet)
  dge <- calcNormFactors(dge)
  logCPM <- cpm(dge,log = TRUE,prior.count = 3)
  v <- voom(dge,design, plot = T, normalize="quantile")
  fit <- lmFit(v,design)
  
  cont.matrix=makeContrasts(contrasts = c("Me-Other"),levels = design)
  fit2=contrasts.fit(fit,cont.matrix)
  fit2=eBayes(fit2)
  
  tempOutput = topTable(fit2, coef = 'Me-Other', n=Inf)
  DEG_limma_voom = na.omit(tempOutput)
  head(DEG_limma_voom) 
  return(DEG_limma_voom)
}
}
#无须搞懂

group_list = ifelse(df$g == 1,"Me","Other") 
table(group_list)
deg1=do_limma_RNAseq(experSet,group_list)
boxplot(dat['Prelid1',]~df$g)
boxplot(dat['Shank1',]~df$g)
boxplot(dat[rownames(deg1)[1],]~df$g)
#boxplot可查看该基因是相对于在其他细胞中是上调还是下调

group_list=ifelse(df$g==2,'Me','Other');table(group_list)
deg2=do_limma_RNAseq(experSet,group_list)
boxplot(dat[rownames(deg2)[1],]~df$g)


group_list=ifelse(df$g==3,'Me','Other');table(group_list)
deg3=do_limma_RNAseq(experSet,group_list)


group_list=ifelse(df$g==4,'Me','Other');table(group_list)
deg4=do_limma_RNAseq(experSet,group_list)
save(deg1,deg2,deg3,deg4,file = "./Rscript/scRNA_seq/step8-deg.Rdata")

load(file = "./Rscript/scRNA_seq/step8-deg.Rdata")

deg1=deg1[order(deg1$logFC,decreasing = T),]
deg2=deg2[order(deg2$logFC,decreasing = T),]
deg3=deg3[order(deg3$logFC,decreasing = T),]
deg4=deg4[order(deg4$logFC,decreasing = T),]



cg=c(head(rownames(deg1),18),
    head(rownames(deg2),18),
    head(rownames(deg3),18),
    head(rownames(deg4),18)
)
library(pheatmap)
cg=c(head(rownames(deg1),18))
g=df$g
mat=dat[cg,]
mat=mat[,order(g)]
ac=data.frame(group=g)
rownames(ac)=colnames(dat)
mat=mat[head(rownames(deg1),18),]
n=t(scale(t(mat)))
pheatmap(n,show_rownames = T,show_colnames = F,cluster_rows = F,cluster_cols = F,annotation_col = ac,filename = "./Rscript/scRNA_seq/step8-deg1_top18_pheatmap.png")
#deg2,deg3,deg4同上可以画热图，最终结果是将四个图拼在一起

plot(deg1$logFC,-log10(deg1$adj.P.Val))

with(deg1,plot( logFC,-log10( adj.P.Val)))
with(deg2,plot( logFC,-log10( adj.P.Val)))
with(deg3,plot( logFC,-log10( adj.P.Val)))
with(deg4,plot( logFC,-log10( adj.P.Val)))

#差异基因
diff1=rownames(deg1[abs(deg1$logFC)>3,])
diff2=rownames(deg2[abs(deg2$logFC)>3,])
diff3=rownames(deg3[abs(deg3$logFC)>3,])
diff4=rownames(deg4[abs(deg4$logFC)>3,])

library(ggplot2)
library(clusterProfiler)
library(org.Mm.eg.db)
#SYMBOL 转 ENTREID
df <- bitr(diff1, fromType = "SYMBOL",
           toType = c( "ENTREZID"),
           OrgDb = org.Mm.eg.db)
#KEGG注释
kk  <- enrichKEGG(gene         = df$ENTREZID,
                  organism     = 'mmu', 
                  pvalueCutoff = 0.9,
                  qvalueCutoff =0.9)
head(kk)[,1:6]
png("./Rscript/scRNA_seq/step8-deg1-kegg-dotplot.png",width = 800,height = 800)
dotplot(kk)
dev.off()







