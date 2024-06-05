JOB_NAME="M1_tea_split_bam"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 60:00
#BSUB -n 1
#BSUB -M 100000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out
#BSUB -J $JOB_NAME

cd $DIR
module load python3/3.6.3

python general_filter_bam_file_with_cell_annotation.py \
/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_anno_by_port/tea_seq_AS_TEAr_M1_r7_annotation.tsv \
/data/salomonis2/Grimes/RNA/scRNA-Seq/10x-Genomics/LGCHMC35_Xuan/211202_Grimes_GSL-PY-2514_TEA-Seq/cellRanger-ARC/AS_TEAr_ML1/AS_TEAr_ML1/outs/atac_possorted_bam.bam \
/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_split_bams/M1/


EOF
# ./<script_name> | bsub
