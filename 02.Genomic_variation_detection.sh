mkdir /project/TM/02.mummer/Strain1
/Software/mummer3/MUMmer3.23/nucmer --prefix /project/TM/02.mummer/Strain1/Strain1 /project/TM/GCF_009556855.1_ASM955685v1_genomic.fna /project/TM/00.Assembly/Strain.fasta
/Software/mummer3/MUMmer3.23/delta-filter -i 89 -l 1000 -1 /project/TM/02.mummer/Strain1/Strain1.delta > /project/TM/02.mummer/Strain1/Strain1.delta.filter
/Software/mummer3/MUMmer3.23/show-coords -r /project/TM/02.mummer/Strain1/Strain1.delta.filter > /project/TM/02.mummer/Strain1/Strain1.delta.coord
/Software/mummer3/MUMmer3.23/show-snps /project/TM/02.mummer/Strain1/Strain1.delta.filter -r -T -C > /project/TM/02.mummer/Strain1/Strain1.delta.snp
