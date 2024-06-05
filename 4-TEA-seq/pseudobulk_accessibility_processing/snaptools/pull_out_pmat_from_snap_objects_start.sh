#!/bin/bash

JOB_NAME="get_pmats_from_snap"
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

module load R/3.5.0

Rscript pull_out_pmat_from_snap_objects.R

EOF