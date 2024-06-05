JOB_NAME="bam_parsing"
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 12:00
#BSUB -n 4
#BSUB -R "span[ptile=4]"
#BSUB -M 200000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out
#BSUB -J $JOB_NAME


module load R/4.0.2

cd /data/salomonis2/LabFiles/Kyle/Analysis/2023_05_28_multilin_celltag_update/output/

Rscript \
/data/salomonis2/LabFiles/Kyle/Analysis/2023_05_28_multilin_celltag_update/scripts/celltag/bam_parsing.R \
/data/salomonis2/LabFiles/Kyle/Analysis/2023_05_28_multilin_celltag_update/input/config_file.csv

EOF