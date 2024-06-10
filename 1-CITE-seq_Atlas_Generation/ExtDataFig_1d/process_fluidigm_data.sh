module load rsem/1.2.19 bowtie2/2.1.0

# Gives TPM values
rsem-calculate-expression  --bowtie2 \
    --bowtie2-path /usr/local/bowtie2/2.1.0/bin \
    -p 4 $FASTQ1  Genomes/mouse_mm10_ucsc/rsem_k_mm10_bt2index/mm10 \
    $SAMPLE