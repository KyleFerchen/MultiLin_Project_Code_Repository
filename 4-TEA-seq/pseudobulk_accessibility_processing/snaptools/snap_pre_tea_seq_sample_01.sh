#!/bin/bash

JOBNUM=$1
SAMPLE=$(basename $JOBNUM .txt)
DIR=$(pwd)

SAMPLE_NAME="AS_TEAr_H1_atac"
SNAP_FILE_NAME="${SAMPLE_NAME}.snap"
PATH_TO_FRAGMENTS="${SAMPLE_NAME}.bed.gz"
PATH_TO_INPUT_FILES="/data/salomonis2/LabFiles/Kyle/Analysis/2022_01_11_mouse_tea_seq_atac/input/snap_atac_input/"

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 12:00
#BSUB -n 4
#BSUB -R "span[ptile=4]"
#BSUB -M 100000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out
#BSUB -J $SAMPLE

cd $DIR

module load python/2.7.15

cd $PATH_TO_INPUT_FILES

snaptools snap-pre \
	--input-file=$PATH_TO_FRAGMENTS \
	--output-snap=$SNAP_FILE_NAME \
	--genome-name=mm10 \
	--genome-size=/data/salomonis2/LabFiles/Kyle/Reference/genomes/mm10/mm10.chrom.sizes \
	--min-mapq=30 \
	--min-flen=50 \
	--max-flen=1000 \
	--keep-chrm=TRUE \
	--keep-single=FALSE \
	--keep-secondary=False \
	--overwrite=True \
	--max-num=20000 \
	--min-cov=500 \
	--verbose=True


snaptools snap-add-bmat \
    --snap-file=$SNAP_FILE_NAME \
    --bin-size-list 1000 5000 10000 \
    --verbose=True

EOF