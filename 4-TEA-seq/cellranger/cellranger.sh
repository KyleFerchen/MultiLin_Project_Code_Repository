INPUTFILE=$1
SAMPLE=$(basename $INPUTFILE .txt) #removes the .txt from the file name only (parent folder name)
DIR=$(pwd)


read -p "Enter your sample name: " INPUTFILE
read -p "Enter your species database name hg19 or mm10-v2: " SPECIESDATABASE

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 30:00
#BSUB -n 2
#BSUB -R "span[ptile=4]"
#BSUB -M 132000
#BSUB -e J.err
#BSUB -o J.out
#BSUB -J $SAMPLE

cd $DIR

module load cellranger/5.0.1
module load bcl2fastq/2.20.0

cellranger count --id=$INPUTFILE  --libraries=library.csv --transcriptome=/database/cellranger/$SPECIESDATABASE  --feature-ref=Mouse-ADT-Custom.csv  --localmem 132   --include-introns  --chemistry=ARC-v1

EOF
