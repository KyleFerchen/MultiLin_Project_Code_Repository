#!/bin/bash

JOB_NAME="merge_r7_peak_sets_py"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 12:00
#BSUB -n 1
#BSUB -M 200000
#BSUB -e $DIR/logs/%J_$JOB_NAME.err
#BSUB -o $DIR/logs/%J_$JOB_NAME.out
#BSUB -J $JOB_NAME

cd $DIR

module load python3/3.6.3

python merge_r7_cluster_peak_sets.py

EOF