rm(list = ls())
library(grid)
library(maftools)
#一：Visualization:maf from annova_txt
merge_maf <- paste0("E:/R-3.5.3/zys_learnR/Data/maftools/merge_maf/sample_merge.maf")
laml <- read.maf(maf = merge_maf)
#1.plotmafSummary:概览maf文件
plotmafSummary(maf = laml, rmOutlier = TRUE, addStat = 'median', 
               dashboard = TRUE, titvRaw = FALSE)

#2.oncoplot:瀑布图
oncoplot(maf = laml ,top = 20 )

#3.Oncostrip:draw any number of genes using top or genes arguments.
oncostrip(maf = laml, genes = c('KRAS','TP53', 'APC'))

#4.plotTiTv:箱线图
#one.function classifies SNPs into Transitions and Transversions 
#two.returns a list of summarized tables in various ways.
laml.titv = titv(maf = laml, plot = FALSE, useSyn = TRUE)
plotTiTv(res = laml.titv)

#5.lollipopPlot：showing mutation spots on protein structure,eg:TP53
lollipopPlot(maf = laml, gene = 'TP53', AACol = 'AAChange', 
             showMutationRate = TRUE)

#6.rainfallPlot:characterized by genomic loci with localized hyper-mutations
#if detectChangePoints = TRUE：rainfall plot also highlights regions where potential changes in inter-event distances are located.
rainfallPlot(maf = laml, pointSize = 0.6,detectChangePoints = TRUE)

#7.tcgaCompare:draws distribution of variants compiled from over 10,000 WXS samples across 33 TCGA landmark cohorts.
laml.mutload = tcgaCompare(maf = laml, cohortName = 'Example-LAML')

#8.plotVaf:plots Variant Allele Frequencies as a boxplot
plotVaf(maf = laml, vafCol = 'Tumor_vaf')

#9.geneCloud:plot word cloud plot for mutated genes
geneCloud(input = laml, minMut = 3)


#二.Analysis
#1.somaticInteractions:detect Many disease causing genes in cancer are co-occurring or show strong exclusiveness in their mutation pattern.
somaticInteractions(maf = laml, top = 25, pvalue = c(0.05, 0.1))

#2. oncodrive:Detecting cancer driver genes based on positional clustering

#3.plotOncodrive: plots the results as scatter plot with size of the points proportional to the number of clusters found in the gene
laml.sig = oncodrive(maf = laml, AACol = 'AAChange', minMut = 5, pvalMethod = 'zscore')
pdf("E:/R-3.5.3/zys_learnR/Data/maftools/Graph/sample_plotOncodrive.pdf")
plotOncodrive(res = laml.sig, fdrCutOff = 0.1, useFraction = TRUE)
dev.off()
##ERROR
pfamDomains(maf = laml, AACol = "Protein_Change")

##OncogenicPathways :checks for enrichment of known Oncogenic Signaling Pathways in TCGA cohorts
OncogenicPathways(maf = laml)
PlotOncogenicPathways(maf = laml, pathways = "RTK-RAS")
#Tumor suppressor genes are in red, and oncogenes are in blue font.



#inferHeterogeneity:uses t_vaf information to cluster variants (using mclust), to infer clonality
SYM.het = inferHeterogeneity(maf = laml, tsb = 'SYM_20181111002-4_14758', vafCol = 't_vaf')
plotClusters(clusters = SYM.het)
# result shows 1：major clone is ~10%
# 2:MATH scores :quantitative measure of intra-tumor heterogeneity,Higher MATH scores are found to be associated with poor outcome.


library(BSgenome.Hsapiens.UCSC.hg19, quietly = TRUE)
laml.tnm = trinucleotideMatrix(maf = laml, prefix = '', add = TRUE, ref_genome = "BSgenome.Hsapiens.UCSC.hg19")
plotApobecDiff(tnm = laml.tnm, maf = laml)

#drugInteractions：function checks for drug–gene interactions and gene druggability information compiled from Drug Gene Interaction database.
dgi = drugInteractions(maf = laml, fontSize = 0.75)

fab.ce = clinicalEnrichment(maf = laml, clinicalFeature = 'FAB_classification')

