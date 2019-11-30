### Create: zhaoys
### Date: 2019-11-20
### Email: 125588933@qq.com
rm(list = ls()) 
options(stringsAsFactors = F)
a=read.table("./Rscript/scRNA_seq/GSE111229_Mammary_Tumor_fibroblasts_768samples_rawCounts.txt",header = T,sep = "\t")
a[1:4,1:4]
if(F){
#定义基因长度为:非冗余exon长度之和
library("TxDb.Mmusculus.UCSC.mm10.knownGene")
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene
exon_txdb <- exons(txdb)
genes_txdb <- genes(txdb)
o = findOverlaps(exon_txdb,genes_txdb)
# eg: 1 --- 6729
# exon_txdb[1] --- chr1 4807893-4807982 ---- exon_id:1
# genes_txdb[6729] --- chr1 4807893-4846735 ---- gene_id:18777
t1=exon_txdb[queryHits(o)]
t2=genes_txdb[subjectHits(o)]
t1=as.data.frame(t1)
t1$gene_id = mcols(t2)[,1]
g_l = lapply(split(t1,t1$gene_id), function(x){
#  x=split(t1,t1$gene_id)[[1]]
  tmp=apply(x, 1, function(y){
    y[2]:y[3]
  })
  length(unique(unlist(tmp)))
#  sum(x[,4]) 有冗余片段
})
g_l = data.frame(gene_id = names(g_l),length = as.numeric(g_l))
save(g_l,file = './Rscript/scRNA_seq/step7-nonredundant_exon_g_l.Rdata')
}


if(F){
  #2. 定义基因长度为:最长转录本长度
  t_l = transcriptLengths(txdb)
  head(t_l)
  t_l = na.omit(t_l)
  head(t_l)
  t_l=t_l[order(t_l$gene_id,t_l$tx_len,decreasing = T),]
  # order:排序, decreasing = T:降序(从大到小)
  head(t_l)
  t_l = t_l[!duplicated(t_l$gene_id),] #去重，保留第一个gene_id相同的tx_len
  head(t_l)
  g_l_2=t_l[,c(3,5)]
  save(g_l_2,file = './Rscript/scRNA_seq/step7-longest_transcript_g_l.Rdata')
}

#定义基因长度为非冗余exon的长度之和做conuts转RPKM分析
head(g_l)
library(org.Mm.eg.db)
s2g=toTable(org.Mm.egSYMBOL)
#获取小鼠基因数据库中gene_id和symbol的对应列表
head(s2g)
g_l = merge(g_l, s2g, by = "gene_id")
#merge通过相同列(gene_id)对g_l和s2g进行匹配和拼接

ng = intersect(rownames(a),g_l$symbol) #取基因名的交集

experSet = a[ng,]
lengths = g_l[match(ng,g_l$symbol),2]
head(lengths)
head(rownames(experSet))
experSet[1:4,1:4]
total_count<- colSums(experSet) #文库大小
rpkm <- t(do.call(rbind,lapply(1:length(total_count),function(i){
  10^9*experSet[,i]/lengths/total_count[i]})))
#基因长度：lengths[1]=1122
#experSet[1:4,1:4]:SS2_15_0048_A4细胞对应的0610005C13Rik基因的counts: 1
#total_count[4]=121297:该细胞中得到的total_count:121297 
#该基因在该细胞的RPKM=1*10^9/(1122*121297)
#即:RPKM=counts*10^9/(lengths*total_count)
b=read.table("./Rscript/scRNA_seq/GSE111229_Mammary_Tumor_fibroblasts_768samples_rpkmNormalized.txt",header = T,sep = "\t")
b[1:4,1:4]
rpkm_paper=b[ng,]
rpkm_paper[1:4,1:4]
rpkm[1:4,1:4]
##result:rpkm_paper和rpkm的值差不多
