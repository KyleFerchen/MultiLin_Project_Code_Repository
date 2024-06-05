
DIR=$(pwd)

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 30:00
#BSUB -n 1
#BSUB -R "span[ptile=4]"
#BSUB -M 100000
#BSUB -e $DIR/logs/%J.err
#BSUB -o $DIR/logs/%J.out


cd /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/09-22-GEX/AS_samples/

# ScaP1
cp /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/LGCHMC60-17GEX-6ADT/CELLTAG/run0951_lane9_read1_index1=ScaP1.fastq.gz \
ScaP1/ScaP1_new_celltag/fastqs/ScaP1_S9_L031_R1_001.fastq.gz

cp /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/LGCHMC60-17GEX-6ADT/CELLTAG/run0951_lane9_read2_index1=ScaP1.fastq.gz \
ScaP1/ScaP1_new_celltag/fastqs/ScaP1_S9_L031_R2_001.fastq.gz


# ScaP2
cp /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/LGCHMC60-17GEX-6ADT/CELLTAG/run0951_lane9_read1_index2=ScaP2.fastq.gz \
ScaP2/ScaP2_new_celltag/fastqs/ScaP2_S10_L031_R1_001.fastq.gz

cp /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/LGCHMC60-17GEX-6ADT/CELLTAG/run0951_lane9_read2_index2=ScaP2.fastq.gz \
ScaP2/ScaP2_new_celltag/fastqs/ScaP2_S10_L031_R2_001.fastq.gz


# ScaNeg1
cp /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/LGCHMC60-17GEX-6ADT/CELLTAG/run0951_lane9_read1_index3=ScaNeg1.fastq.gz \
ScaNeg1/ScaNeg1_new_celltag/fastqs/Sca1_S11_L031_R1_001.fastq.gz

cp /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/LGCHMC60-17GEX-6ADT/CELLTAG/run0951_lane9_read2_index3=ScaNeg1.fastq.gz \
ScaNeg1/ScaNeg1_new_celltag/fastqs/Sca1_S11_L031_R2_001.fastq.gz


# ScaNeg2
cp /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/LGCHMC60-17GEX-6ADT/CELLTAG/run0951_lane9_read1_index4=ScaNeg2.fastq.gz \
ScaNeg2/ScaNeg2_new_celltag/fastqs/Sca2_S12_L031_R1_001.fastq.gz

cp /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/LGCHMC60-17GEX-6ADT/CELLTAG/run0951_lane9_read2_index4=ScaNeg2.fastq.gz \
ScaNeg2/ScaNeg2_new_celltag/fastqs/Sca2_S12_L031_R2_001.fastq.gz


EOF
