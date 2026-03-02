source activate funannotate
cd  /project/TM/01.funannotate

while IFS=$'\t' read -r gca species; do

    if [ -d "$strain" ] && [ -f "$strain/${strain}.fa" ] && [ -d "$strain/predict_results" ] && [ "$(ls -A "$strain/predict_results")" ]; then
        echo "### Skipping $strain: already processed"
        continue
    fi
    
    rm -r "$strain"
    mkdir -p "$strain" 
    cd "$strain" || continue
    echo "#####  $strain START #####"
    cut -d'_' -f1,2 "/project/49.LZT_TM/00.genome/${strain}.fasta" > "${strain}.fa"
    funannotate clean -i "${strain}.fa" -o clearrepeat.fasta --cpus 24
    funannotate mask -i clearrepeat.fasta --cpus 24 -o masker.fasta
    funannotate predict -i masker.fasta -o ./ -s "$species" --cpus 24 --min_training_models 5
    echo "##### $strain END #####"
    cd ..

done < /project/TM/01.funannotate/genome_taxo.list
