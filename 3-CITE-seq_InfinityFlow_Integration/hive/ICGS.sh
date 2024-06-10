INPUTFILE=$1
SAMPLE=$(basename $INPUTFILE) #removes the .txt from the file name only (parent folder name)
DIR=$(pwd)


read -p "Enter your sample name: " INPUTFILE
read -p "Enter the name of species for AltAnalyze i.e Hs, Mm: " SPECIES

OUTPUT=$DIR
TXTFILE=$DIR/seurat_filtered_merged_file_CPTT-log2.txt
ICGS=$OUTPUT/ICGS-NMF

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 30:00
#BSUB -n 2
#BSUB -R "span[ptile=4]"
#BSUB -M 132000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out
#BSUB -J $SAMPLE

cd $DIR

module load cellranger/3.1.0
module load bcl2fastq/2.20.0
module load R/3.5.0
module load python/2.7.5


python /data/salomonis2/software/AltAnalyze/AltAnalyze.py --runICGS yes --platform "RNASeq"  --dataFormat counts  --species $SPECIES --column_method hopach --column_metric cosine --rho 0.2 --ExpressionCutoff 1 --FoldDiff 4 --SamplesDiffering 4 --restrictBy protein_coding --expdir $TXTFILE --output $OUTPUT --excludeCellCycle no --removeOutliers no --dataFormat scaled

mv $ICGS $OUTPUT/ICGS-NMF_cosine_cc

python /data/salomonis2/software/AltAnalyze/AltAnalyze.py --runICGS yes --platform "RNASeq" --species $SPECIES --dataFormat counts   --column_method hopach --column_metric euclidean --rho 0.2 --ExpressionCutoff 1 --FoldDiff 4 --SamplesDiffering 4 --restrictBy protein_coding --expdir $TXTFILE --output $OUTPUT --excludeCellCycle no --removeOutliers no --dataFormat scaled

mv $ICGS $OUTPUT/ICGS-NMF_euclidean_cc

python /data/salomonis2/software/AltAnalyze/AltAnalyze.py --runICGS yes --platform "RNASeq" --species $SPECIES --dataFormat counts  --column_method hopach --column_metric cosine --rho 0.2 --ExpressionCutoff 1 --FoldDiff 4 --SamplesDiffering 4 --restrictBy protein_coding --excludeCellCycle conservative --expdir $TXTFILE --output $OUTPUT --removeOutliers no   --dataFormat scaled

mv $ICGS $OUTPUT/ICGS-NMF_cosine

python /data/salomonis2/software/AltAnalyze/AltAnalyze.py --runICGS yes --platform "RNASeq" --species $SPECIES --column_method hopach --dataFormat counts  --column_metric euclidean --rho 0.2 --ExpressionCutoff 1 --FoldDiff 4 --SamplesDiffering 4 --restrictBy protein_coding --excludeCellCycle conservative --expdir $TXTFILE --output $OUTPUT --removeOutliers no   --dataFormat scaled

mv $ICGS $OUTPUT/ICGS-NMF_euclidean

EOF


