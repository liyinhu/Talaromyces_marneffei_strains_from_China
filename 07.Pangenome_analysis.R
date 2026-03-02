# Core / Accessory / Unique orthogroups

library(tidyverse)

df <- read_tsv(/project/TM/04.pangenome/Proteins/OrthoFinder/Orthogroups/Orthogroups.GeneCounts.tsv)

n_genomes <- ncol(df) - 1

# Core orthogroups (count > 0)
df_core <- df %>% filter(rowSums(.[,2:ncol(.)] > 0) == n_genomes)

# Accessory orthogroups (1 < presence < n)
df_accessory <- df %>% filter(rowSums(.[,2:ncol(.)] > 0) < n_genomes & rowSums(.[,2:ncol(.)] > 0) > 1)

# Unique orthogroups (only exists in 1 strain)
df_unique <- df %>% filter(rowSums(.[,2:ncol(.)] > 0) == 1)

write_tsv(df_core, "core_orthogroups.tsv")
write_tsv(df_accessory, "accessory_orthogroups.tsv")
write_tsv(df_unique, "unique_orthogroups.tsv")

cat("Core:", nrow(df_core), "\n")
cat("Accessory:", nrow(df_accessory), "\n")
cat("Unique:", nrow(df_unique), "\n")


#Pan-genome dilution curves

library(tidyverse)

og <- read.delim(/project/TM/04.pangenome/Proteins/OrthoFinder/Orthogroups/Orthogroups.tsv, sep="\t", check.names = FALSE)

strains <- colnames(og)[-1]
N <- length(strains)

# binary presence/absence matrix
pa <- og
pa[pa != "" & pa != "-" ] <- 1
pa[pa == "" | pa == "-" ] <- 0
pa[, -1] <- apply(pa[, -1], 2, as.numeric)

n_replicates <- 100

pangenome_curve <- matrix(0, nrow=n_replicates, ncol=N)
coregenome_curve <- matrix(0, nrow=n_replicates, ncol=N)

set.seed(123)

for (i in 1:n_replicates) {
  order <- sample(strains, N, replace = FALSE)
  
  present <- rep(0, nrow(pa))
  
  for (k in 1:N) {
    s <- order[k]
    present <- present + pa[[s]]
    
    # Pangenome
    pangenome_curve[i, k] <- sum(present > 0)
    
    # Coregenome
    coregenome_curve[i, k] <- sum(present == k)
  }
}

pang_mean <- apply(pangenome_curve, 2, mean)
pang_sd   <- apply(pangenome_curve, 2, sd)

core_mean <- apply(coregenome_curve, 2, mean)
core_sd   <- apply(coregenome_curve, 2, sd)

df <- data.frame(
  genomes = 1:N,
  pan_mean = pang_mean,
  pan_sd   = pang_sd,
  core_mean = core_mean,
  core_sd   = core_sd
)

# Visulization
library(ggplot2)

ggplot(df, aes(x = genomes)) +
    geom_line(aes(y = pan_mean, color = "Pangenome size"), size = 1.2) +
    geom_ribbon(aes(ymin = pan_mean - pan_sd, ymax = pan_mean + pan_sd, fill = "Pangenome"), alpha = 0.2) +
    
    geom_line(aes(y = core_mean, color = "Core genome size"), size = 1.2) +
    geom_ribbon(aes(ymin = core_mean - core_sd, ymax = core_mean + core_sd, fill = "Core"), alpha = 0.2) +
    
    scale_color_manual(values = c("Pangenome size"= "#56B4E9", "Core genome size"="#D86C76")) +
    scale_fill_manual(values = c("Pangenome"="#56B4E9", "Core"="#D86C76")) +
    
    labs(
        x = "Number of genomes",
        y = "Number of orthogroups",
        color = "",
        fill = "",
        title = "Pangenome Accumulation Curve (Orthofinder)"
    ) +
    theme_minimal(base_size = 14)+
    theme_bw() +
    theme(panel.grid = element_blank(),
          legend.position = "right")
