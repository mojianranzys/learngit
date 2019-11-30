### Create: zhaoys
### Date: 2019-11-12
### Email: 125588933@qq.com

#在单细胞测序中起始RNA含量越低，技术重复样本的基因表达相关性也越低，
#因此生成标准化的基因表达谱之后，非常重要的一步是评估技术噪音（technical variability），常见的一种方法是计算基因表达值的变异系数的平方（CV^2）
#重现文章中的变异系数CV图,C.V(Coefficient of Vartance)= sd/mean

rm(list = ls()) 
options(stringsAsFactors = F)
load(file = './Rscript/scRNA_seq/input_rpkm.Rdata')
dat[1:4,1:4]
exprSet=dat
mean_per_gene <- apply(exprSet, 1, mean, na.rm = T) #求表达矩阵每行的均值
sd_per_gene <- apply(exprSet, 1, sd, na.rm = T) #求表达矩阵每行的标准差
#mad_per_gene <- apply(exprSet, 1, sd, na.rm = T) #求表达矩阵每行的绝对中位差

cv_per_gene <- data.frame(mean = mean_per_gene,
                          sd = sd_per_gene,
                          cv = sd_per_gene/mean_per_gene)
rownames(cv_per_gene) <- rownames(exprSet)
with(cv_per_gene,plot(log10(mean),log10(cv^2)))
cv_per_gene$log10cv2=log10(cv_per_gene$cv^2)
cv_per_gene$log10mean=log10(cv_per_gene$mean)
library(ggpubr)
cv_per_gene=cv_per_gene[cv_per_gene$log10mean > 0 & cv_per_gene$log10mean < 4 , ]

ggscatter(cv_per_gene, x = 'log10mean', y = 'log10cv2',
          color = "black", shape = 16, size = 1, # Points color, shape and size
          xlab = 'log10(mean)RPKM', ylab = "log10(cv^2)",
          add = "loess", #添加拟合曲线
          add.params = list(color = "red",fill = "lightgray"),
          cor.coef = T, #添加相关系数和p-value值'
          conf.int = TRUE, # 添加置信区间
          cor.coeff.args = list(method =  "spearman"), 
          label.x = 3,label.sep = "\n",
          dot.size = 1,
          ylim=c(-0.5, 3),
          xlim=c(0,4) 
)
ggsave('./Rscript/scRNA_seq/all_cells_CV_rpkm.png')



