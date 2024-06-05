#!/bin/bash

JOB_NAME="peaks_to_10_columns"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 1:00
#BSUB -n 1
#BSUB -M 4000
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

echo "loading anaconda3"
module load anaconda3

echo "activating conda env"
source activate /users/fero3l/Env/chrombpnet

# echo "loading cuda"
# module load cuda/11.7

python add_columns_to_peak_bed_file_for_10_format.py

EOF
# ./<script_name> | bsub