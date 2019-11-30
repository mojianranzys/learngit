### Create: zhaoys
### Date: 2019-11-13
### Email: 125588933@qq.com
##gene number
rm(list = ls()) 
options(stringsAsFactors = F)
load(file = './Rscript/scRNA_seq/input_rpkm.Rdata')
dat[1:4,1:4]
group_list=df$g
table(group_list)
plate=df$plate
table(plate)

#step_0: n_g = apply(rawcount_mat,2,function(x) sum(x>0)) #统计每个样本有表达的有多少行（基因）
library(ggpubr)
head(df)
#绘制检测到的所有基因的小提琴图
ggviolin(df, x = "all", y = "n_g", fill = "all", add = "boxplot", add.params = list(fill = "white")) 
ggsave(file = './Rscript/scRNA_seq/all_genes_numbers_rpkm.png')

#绘制不同批次检测到的基因的小提琴图
ggviolin(df, x = "plate", y = "n_g", fill = "plate",add = "boxplot", add.params = list(fill = "white")) 
ggsave(file = './Rscript/scRNA_seq/two_plate_all_genes_numbers_rpkm.png')

#绘制不同细胞种类检测到的基因的小提琴图,stat_compare_means(): 增加p_value
ggviolin(df, x = "g", y = "n_g", fill = "g",add = "boxplot", add.params = list(fill = "white"))  + stat_compare_means()
ggsave(file = './Rscript/scRNA_seq/four_type_cells_all_genes_numbers_rpkm.png')
