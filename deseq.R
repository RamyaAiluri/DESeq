# Step 1: Data preparation
library(DESeq2)

# Import count data
countMatrix <- read.table("C:/Users/railuri/OneDrive/Desktop/vcf_files/transposed_data.csv", header = TRUE, row.names = TRUE, sep = ",")
countMatrix <- round(apply(countMatrix,2,as.numeric))
# Create metadata table with unique row names
metadata <- read.table("C:/Users/railuri/OneDrive/Desktop/vcf_files/metadata.txt", header = TRUE, row.names=NULL, sep = "\t")

# Step 2: Create DESeq2 object
dds <- DESeqDataSetFromMatrix(countData = countMatrix, colData = DataFrame(metadata$sample), design = ~ metadata$condition)

# Step 3: Perform normalization
dds <- estimateSizeFactors(dds)
normalizedCounts <- counts(dds, normalized = TRUE)

# Step 4: Statistical modeling and differential expression analysis
dds <- DESeq(dds)
results <- results(dds, contrast = c("condition", "ctl", "cancer"))

# Step 5: Explore and visualize results
plotPCA(dds, intgroup = "condition")
plotMA(results)
plotCounts(dds, gene = "GeneOfInterest")

# Adjust p-values for multiple testing
results <- lfcShrink(dds, contrast = c("condition", "ctl", "cancer"), res = results)

# Generate a volcano plot
volcanoPlot(results)

# Generate a heatmap of differentially expressed genes
heatmap(assay(dds)[row.names(results)[results$padj < 0.05],])
