#!/bin/bash

JOBNUM=$1
SAMPLE=$(basename $JOBNUM .txt)
DIR=$(pwd)

path_to_atac_fragments="/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC35_Xuan/211202_Grimes_GSL-PY-2514_TEA-Seq/cellRanger-ARC/AS_TEAr_ML1/AS_TEAr_ML1/outs/atac_fragments.tsv.gz"
path_to_atac_barcodes="/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC35_Xuan/211202_Grimes_GSL-PY-2514_TEA-Seq/cellRanger-ARC/AS_TEAr_ML1/AS_TEAr_ML1/outs/filtered_feature_bc_matrix/barcodes.tsv.gz"
path_to_save="/data/salomonis2/LabFiles/Kyle/Analysis/2022_01_11_mouse_tea_seq_atac/input/snap_atac_input/"
sample_name="AS_TEAr_ML1_atac"

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 12:00
#BSUB -n 4
#BSUB -R "span[ptile=4]"
#BSUB -M 32000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out
#BSUB -J $SAMPLE

cd $path_to_save

gunzip -c $path_to_atac_fragments \
> "${sample_name}.tsv"

zcat $path_to_atac_fragments | head -n 53

sed '1,52d' "${sample_name}.tsv" > "${sample_name}_no_header.tsv"
sort -k4,4 "${sample_name}_no_header.tsv" > "${sample_name}.bed"
rm "${sample_name}_no_header.tsv"
gzip "${sample_name}.bed"
rm "${sample_name}.tsv"

gunzip -c $path_to_atac_barcodes \
> "${sample_name}_barcodes.tsv"

EOF
