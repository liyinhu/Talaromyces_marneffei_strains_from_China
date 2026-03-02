VCF="All_TM_strains.vcf.gz"

# 1) per-cluster nucleotide diversity (site pi)
for g in ./group*.txt; do
  bname=$(basename $g .txt)
  vcftools --gzvcf $VCF --keep $g --site-pi --out ./${bname}.sitepi
  # windowed pi (e.g. 10 kb windows; adjust --window-pi accordingly)
  vcftools --gzvcf $VCF --keep $g --window-pi 10000 --out ./${bname}.win.pi
done

# 2) Tajima's D per cluster
for g in ./group*.txt; do
  bname=$(basename $g .txt)
  vcftools --gzvcf $VCF --keep $g --TajimaD 10000 --out ./${bname}.tajimaD
done

# 3) pairwise Fst (Weir & Cockerham) between clusters
groups=(./group*.txt)
for ((i=0; i<${#groups[@]}; i++)); do
	for ((j=i+1; j<${#groups[@]}; j++)); do
		g1="${groups[$i]}"
		g2="${groups[$j]}"
		p1=$(basename "$g1" .txt)
		p2=$(basename "$g2" .txt)
		vcftools --gzvcf $VCF --weir-fst-pop "$g1" --weir-fst-pop "$g2" --out "./${p1}_vs_${p2}"
	done
done
