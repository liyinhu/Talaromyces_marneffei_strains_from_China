for sample in /mnt/Workspace/Project/03.LZT_assembly/02.align/03.SNP_annotation/SNP_anno/*_filter_snp_annotated.vcf; do
    name=$(basename $sample _filter_snp_annotated.vcf)
    echo "Sample: $name"

    # Different types variations
    synonymous=$(java -jar /home/yinhu/Software/snpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'synonymous_variant')" $sample | grep -v "^#" | wc -l)
    missense=$(java -jar /home/yinhu/Software/snpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'missense_variant')" $sample | grep -v "^#" | wc -l)
    stop_gained=$(java -jar /home/yinhu/Software/snpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'stop_gained')" $sample | grep -v "^#" | wc -l)
    stop_lost=$(java -jar /home/yinhu/Software/snpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'stop_lost')" $sample | grep -v "^#" | wc -l)
    frameshift=$(java -jar /home/yinhu/Software/snpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'frameshift_variant')" $sample | grep -v "^#" | wc -l)
    splice_donor=$(java -jar /home/yinhu/Software/snpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'splice_donor_variant')" $sample | grep -v "^#" | wc -l)
    splice_acceptor=$(java -jar /home/yinhu/Software/snpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'splice_acceptor_variant')" $sample | grep -v "^#" | wc -l)
    intron=$(java -jar /home/yinhu/Software/snpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'intron_variant')" $sample | grep -v "^#" | wc -l)
    intergenic=$(java -jar /home/yinhu/Software/snpEff/SnpSift.jar filter "(ANN[*].EFFECT has 'intergenic_variant')" $sample | grep -v "^#" | wc -l)

    # Results output
    echo "$name\t$synonymous\t$missense\t$stop_gained\t$stop_lost\t$frameshift\t$splice_donor\t$splice_acceptor\t$intron\t$intergenic" >> SNP_summary.tsv
done
