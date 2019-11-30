### Create: zhaoys
### Date: 2019-11-15
### Email: 125588933@qq.com
rm(list = ls()) 
options(stringsAsFactors = F)
load(file = './Rscript/scRNA_seq/input.Rdata')
head(df)
group_list=df$g
plate=df$plate
table(plate)
dat[1:4,1:4]
rownames(dat)=toupper(rownames(dat)) ##基因名全部转为大写


t_dat = t(dat)
gene_names = colnames(t_dat)

library(org.Hs.eg.db)
#导入人类基因信息的包
s2g=toTable(org.Hs.egSYMBOL)
#生成gene_id与sample的对应的列表
match_g=s2g[match(gene_names,s2g$symbol),1]
#因为小鼠没有PAM50分类器，所以暂时用人类的代替
# match（x, y）返回的是x中每个元素在y中对映的位置，
# 如果x不在y中，该元素处返回的是NA

dannot=data.frame(probe=gene_names, "Gene.Symbol" =gene_names, "EntrezGene.ID"=match_g)
#gene_names是检测到的基因的名称
#match_g是b标准基因ID
dim(t_dat)
t_dat = t_dat[,!is.na(dannot$EntrezGene.ID)]
#去除没有匹配到的基因（NA的列），即剔除无基因ID对应的列,且进行ID转换
dim(t_dat)
library(pheatmap)
library("genefu")
# 包含了c("scmgene", "scmod1", "scmod2","pam50", "ssp2006", "ssp2003", "intClust", "AIMS","claudinLow")

#分子分型，乳腺癌PAM50: c("LumA ", "LumB",  "Basal", "Her2", "Normal") 
m_type <- molecular.subtyping(sbt.model = "pam50",data=t_dat,annot=dannot,do.mapping=TRUE)
table(m_type$subtype)
aa <- as.data.frame(table(m_type$subtype))
png('./Rscript/scRNA_seq/all_cells_PAM50_molecular_substype.png',width=500,height=500)
pie(aa$Freq, labels = aa$Var1, main = "PAM50 molecular substype")
dev.off()

#cell_subtype=as.data.frame(m_type$subtype)
subtypes=as.character(m_type$subtype)
head(df)
df$subtypes=subtypes
table(df[,c(1,5)])
bb = table(df[,c(1,5)])
barplot(bb)
#计算不用细胞类型对应的分析分型的数量

data(pam50)
pam50genes = pam50$centroids.map[c(1,3)]
#取pam50的基因名(probe)和EntrezGene.ID

pam50genes[pam50genes$probe=='CDCA1',1]='NUF2'
pam50genes[pam50genes$probe=='KNTC2',1]='NDC80'
pam50genes[pam50genes$probe=='ORC6L',1]='ORC6'
#上述三个基因名称存在别名，需修改

dim(dat)
dat_pam50 = dat[pam50genes$probe[pam50genes$probe %in% rownames(dat)],]
table(group_list)
tmp2=data.frame(group=group_list,subtypes=subtypes)
rownames(tmp2)=colnames(dat_pam50)

library(pheatmap)

pheatmap(dat_pam50,show_rownames = T,show_colnames = F,
         annotation_col = tmp2,
         filename = './Rscript/scRNA_seq/ht_by_pam50.png') 





