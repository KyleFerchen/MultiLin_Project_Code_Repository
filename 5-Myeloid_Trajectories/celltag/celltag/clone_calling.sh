
JOB_NAME="clone_calling"
DIR=$(pwd)


cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 30:00
#BSUB -n 2
#BSUB -R "span[ptile=4]"
#BSUB -M 100000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out
#BSUB -J $JOB_NAME

cd $DIR

module load python3

python ./clone_calling.py


EOF
# ./cellranger_count<>.sh | bsub