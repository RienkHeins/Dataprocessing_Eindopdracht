args = commandArgs(trailingOnly=TRUE)

data <- args[1]
design <- args[2]
output <- args[3]
log_file <- args[4]

log <- file(log_file, open="wt")
sink(log)


suppressPackageStartupMessages({library(DESeq2)})


cov_data <- read.table(data, sep="\t", row.names = 1, header=T)
design_table <- read.table(design, sep="\t", row.names = 1, header=T)
conditions <- as.character(design_table[,1])

exp_cond <- data.frame(row.names=colnames(cov_data), condition = conditions)
DESeq_dataset <- DESeqDataSetFromMatrix(countData=cov_data, colData=exp_cond, design=~condition)
print ("Start DESeq2")
DESeq_norm <- DESeq(DESeq_dataset)


rlog_tf <- rlog(DESeq_norm)
distances <- dist(t(assay(rlog_tf)))
distance_matrix <- as.matrix(distances)
rownames(distance_matrix) <- colnames(distance_matrix)

suppressPackageStartupMessages({library(RColorBrewer)})
suppressPackageStartupMessages({library(gplots)})

palette <-colorRampPalette(brewer.pal(9,"GnBu"))(100)
hierarchy <- hclust(distances)

print ("Print Dendrogram_and_heatmap.")
pdf(paste(output, "Dendrogram_and_heatmap.pdf", sep=""))
heatmap.2(distance_matrix,Rowv=as.dendrogram(hierarchy), symm=TRUE, trace="none", col=rev(palette))
dev.off()
print ("Done.")

print ("Print PCA plot.")
pdf(paste(output, "PCA.pdf", sep=""))
plotPCA(rlog_tf, intgroup=c("condition"))
dev.off()
print ("Done.")