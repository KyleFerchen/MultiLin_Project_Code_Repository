# Updating CellTag clone calling with new sequencing data

## CellRanger
### Preparing Files
First, I need to prepare the files for CellRanger by moving the new sequencing
data into the relevant original sequencing data FASTQ folders.

The new data is stored here:
    /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/LGCHMC60-17GEX-6ADT/CELLTAG/

With the folling file names:
    run0951_lane9_read1_index1=ScaP1.fastq.gz
    run0951_lane9_read2_index1=ScaP1.fastq.gz

    run0951_lane9_read1_index2=ScaP2.fastq.gz
    run0951_lane9_read2_index2=ScaP2.fastq.gz
        
    run0951_lane9_read1_index3=ScaNeg1.fastq.gz
    run0951_lane9_read2_index3=ScaNeg1.fastq.gz
        
    run0951_lane9_read1_index4=ScaNeg2.fastq.gz
    run0951_lane9_read2_index4=ScaNeg2.fastq.gz


They need to be moved into the original fastq directories here:
    /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/09-22-GEX/AS_samples/

With the following sub-directories:
    ScaP1/ScaP1_new_celltag/fastqs/
    ScaP2/ScaP2_new_celltag/fastqs/
    ScaNeg1/ScaNeg1_new_celltag/fastqs/
    ScaNeg2/ScaNeg2_new_celltag/fastqs/
    
This was done with the `prepare_files_for_cellranger.sh` script.

### Running CellRanger
First, a logs dir was created to save the logs from each run:

cd /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/09-22-GEX/AS_samples/
mkdir ScaP1/ScaP1_new_celltag/logs/
mkdir ScaP2/ScaP2_new_celltag/logs/
mkdir ScaNeg1/ScaNeg1_new_celltag/logs/
mkdir ScaNeg2/ScaNeg2_new_celltag/logs/


Move the scripts into their matching directory for cellranger:
    ScaP1/ScaP1_new_celltag/cellranger_ScaP1.sh
    ScaP2/ScaP2_new_celltag/cellranger_ScaP2.sh
    ScaNeg1/ScaNeg1_new_celltag/cellranger_ScaNeg1.sh
    ScaNeg2/ScaNeg2_new_celltag/cellranger_ScaNeg2.sh

Run the CellRanger count scripts:
cd /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/09-22-GEX/AS_samples/ScaP1/ScaP1_new_celltag/
./cellranger_ScaP1.sh | bsub

cd /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/09-22-GEX/AS_samples/ScaP2/ScaP2_new_celltag/
./cellranger_ScaP2.sh | bsub

cd /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/09-22-GEX/AS_samples/ScaNeg1/ScaNeg1_new_celltag/
./cellranger_ScaNeg1.sh | bsub

cd /data/salomonis-archive/FASTQs/Grimes/RNA/scRNASeq/10X-Genomics/09-22-GEX/AS_samples/ScaNeg2/ScaNeg2_new_celltag/
./cellranger_ScaNeg2.sh | bsub

## CellTag
### Make configuration file for CellTag pipeline
See example file in the current directory. ('./config_file.csv')

### Extract CellTag barcodes from BAM
`bam_parse.sh`

### Run clone calling
`clone_calling.sh`
