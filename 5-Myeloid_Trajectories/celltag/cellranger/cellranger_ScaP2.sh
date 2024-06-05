INPUTFILE="ScaP2_May_2023_Update"
SAMPLE=$(basename $INPUTFILE .txt) #removes the .txt from the file name only (parent folder name)
DIR=$(pwd)


# read -p "Enter your sample name: " INPUTFILE
#read -p "Enter your species database name hg19 or mm10-v2: " SPECIESDATABASE
#read -p "Enter the name of species for AltAnalyze i.e Hs, Mm: " SPECIES

OUTPUT=$DIR/$INPUTFILE/outs/filtered_feature_bc_matrix
MATRIX=$OUTPUT/matrix.mtx.gz
CPTTFILE=$DIR/$INPUTFILE/${INPUTFILE}_matrix_CPTT.txt


cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 30:00
#BSUB -n 1
#BSUB -R "span[ptile=4]"
#BSUB -M 256000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out
#BSUB -J $SAMPLE

cd $DIR

module load cellranger/7.0.1
module load bcl2fastq/2.20.0


cellranger count --id=$INPUTFILE --transcriptome=/data/salomonis2/LabFiles/Daud/Genomes/gfp/mm10 --fastqs=$DIR/fastqs/ --localmem 132 --force-cells 20000


EOF
