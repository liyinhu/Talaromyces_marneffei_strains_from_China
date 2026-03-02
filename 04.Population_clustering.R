library(SNPRelate)
library(adegenet)
library(tidyverse)
library(ggplot2)

vcf.fn <- "All_TM_strains.vcf.gz"
gds_file <- "All_TM_strains.gds"

# VCF2GDS
snpgdsVCF2GDS(vcf.fn, gds_file, method="biallelic.only")
snpgdsSummary(gds_file)


# PCA analysis
genofile <- snpgdsOpen(gds_file)
pca <- snpgdsPCA(genofile, num.thread=4, autosome.only=FALSE)

pca_df <- data.frame(
    sample = pca$sample.id,
    PC1 = pca$eigenvect[,1],
    PC2 = pca$eigenvect[,2]
)

# Population clustering
set.seed(123)
grp <- find.clusters(pca_df[,2:3], max.n.clust=10) 
grp_assign <- data.frame(sample=pca_df$sample, cluster=grp$grp)
write.table(grp_assign, file="cluster_assignments.txt", sep="\t", quote=FALSE, row.names=FALSE)


# PCA visulizaiton of population clustering
Palette <- c("#B2182B","#56B4E9","#E69F00","#009E73","#F0E442","#0072B2","#D55E00","#CC79A7","#CC6666","#9999CC","#66CC99","#999999","#ADD1E5","#FCAE91","#FEE5D9")

ggplot(pca_df %>% left_join(grp_assign, by="sample"), aes(x = PC1, y = PC2, col =factor(cluster)))+ geom_point(alpha=0.8)+theme_bw()+ scale_color_manual(values = Palette) +theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),axis.line = element_line(colour = "black")) + labs(x=paste0( "PC1"),y=paste0( "PC2"))+stat_ellipse(aes(x = PC1, y = PC2, group=cluster, color=cluster), level = 0.8)


# Clustering results output
clusters <- split(grp_assign$sample, grp_assign$cluster)
for (i in seq_along(clusters)) {
    writeLines(clusters[[i]], con=paste0("group", i, ".txt"))
}
snpgdsClose(genofile)
