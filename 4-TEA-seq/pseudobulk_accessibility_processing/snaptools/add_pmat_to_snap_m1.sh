#!/bin/bash

JOB_NAME="get_new_pmat_M1"
DIR=$(pwd)


PATH_TO_SNAP="/data/salomonis2/LabFiles/Kyle/Analysis/2022_01_11_mouse_tea_seq_atac/input/snap_atac_input/"
SNAP_FILE_NAME="AS_TEAr_ML1_atac.snap"
PATH_TO_PEAKS="/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_macs2_p_0_05_merged_peak_set/r7_tea_p_0_001_merged_peaks_with_tss_added.bed"

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 12:00
#BSUB -n 1
#BSUB -M 100000
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

cd $PATH_TO_SNAP

module load python/2.7.15
module load bedtools/2.30.0
module load gcc/12.2.0


# Remove the old peak-by-cell matrix
echo "Removing previous peak-by-cell matrix for" $SNAP_FILE_NAME
snaptools snap-del \
    --snap-file=$SNAP_FILE_NAME \
    --session-name='PM'

echo "Adding new peak-by-cell matrix for" $SNAP_FILE_NAME
# Add the new peak-by-cell matrix
snaptools snap-add-pmat \
    --snap-file=$SNAP_FILE_NAME \
    --peak-file=$PATH_TO_PEAKS \
    --verbose=True

EOF