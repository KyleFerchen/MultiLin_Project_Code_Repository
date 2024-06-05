### Outline
-[4-TEA-seq](# 4-TEA-seq)



# 4-TEA-seq

In this study, TEA-seq was performed on 2 samples:

1. HSC/MPP gated cells
2. MultiLin gated cells

These populations enrich for the hematopoietic stem cells, the multilineage progenitor populations, and the immediate specification events to unipotent lineages, thought to go through hierarchical lineage restriction.

*Note: although TEA-seq captures surface protein, transcriptomes, and accessibility data, we found that the surface protein data and transcriptome data was not as robust as that obtained from CITE-seq and InfinityFlow. So we prioritized our efforts to map states between CITE-seq and TEA-seq and use the RNA from CITE-seq and the ATAC-based accessibility from TEA-seq for downstream analyses.*

<br>

# I. Initial TEA-seq processing

## 1. cellranger count

***'4-TEA-seq/cellranger_example/cellranger.sh'***

The fastq files after sequencing were processed using the cellranger count program (v5.0.1) with the `--chemistry=ARC-v1`

Eg.:

```shell
cellranger count --id=$INPUTFILE  --libraries=library.csv --transcriptome=/database/cellranger/$SPECIESDATABASE  --feature-ref=Mouse-ADT-Custom.csv  --localmem 132   --include-introns  --chemistry=ARC-v1
```

<br><br>

# II. CITE-seq Label Transfer to TEA-seq Data

## 1. Label transfer using modified pyHarmony algorithm

***'4-TEA-seq/CITE-seq_to_TEA-seq_Label_Transfer/CITE-seq_to_TEA-seq_Label_Transfer.ipynb'***


This notebook walks through the pyHarmony method used to correct for batch effects between CITE-seq and TEA-seq transcriptomes and to transfer the labels from the CITE-seq reference to the TEA-seq cells.

<br>

## 2. Validation of label transfer

***'4-TEA-seq/CITE-seq_to_TEA-seq_Label_Transfer/Validation_of_Label_Transfer.ipynb'***

The label transfer from CITE-seq to TEA-seq is validated by comparing the ranking of marker genes according to gene expression data from both modalities. A spearman correlation value between ranking of top marker genes is compared between each cluster between modalities.

<br><br>

# III. Pseudobulk processing of accessibility data

## 1. Split BAM files to TEA-seq cluster annotations 

***'4-TEA-seq/pseudobulk_accessibility_processing/Splitting_BAM_Files_to_Pseudobulk_Clusters/'***

Each of the *.sh* files in this directory splits the possorted BAM file from cellranger into pseudobulk BAM files.

<br>

## 2. Sort and merge split bams by clusters

***'4-TEA-seq/pseudobulk_accessibility_processing/sort_and_merge_pseudobulk_bam_files/'***

After the BAM files are separated by clusters, the scripts in this directory are used to merge them so that a single BAM file for each cluster can be used downstream.

<br>

***'sort_and_index_\*_bams\*.sh'***

These files sort and index the split BAM files.

<br>

***'merge_r7_bams_h_and_m_\*.sh'***

These scripts merge the BAM files for each cluster.

<br>

***'index_merged_sorted_bams_\*.sh'***

These scripts index the cluster BAM files.

<br><br>

# IV. Call peaks on TEA-seq pseudobulk clusters 

***'4-TEA-seq/pseudobulk_accessibility_processing/call_peaks/'***

These files are used to call peaks on the cluster split BAM files.

<br>

***'./merge_r7_cluster_peak_sets.py'***

This file merges the peak summits. The algorithm orders the summits called by MACS2 by their significance, and then iteratively removes less significant summits that are within a predefined range (+/- 500 bp).

<br><br>

# V. Create BigWig files

>'4-TEA-seq/pseudobulk_accessibility_processing/create_bigwig_files/'

The BigWig files created with the scripts in this directory are used to project the accessibility coverage tracks onto a genome browser.

<br><br>

# VI. Peak by cell matrix and pseudobulk profiles

*Directory for these scripts:*

>'4-TEA-seq/pseudobulk_accessibility_processing/snaptools/'

After peaks have been identified (within individual pseudobulk clusters), we want to represent the single-cell accessibility data from TEA-seq as a peak by cell matrix. This quickly enables downstream analysis of those peaks. Here we use the snaptools program to generate the peak by cell matrix.

## 1. Set up the snap objects

>'prep_tea_seq_sample_\*.sh'

First, the output from the 10X genomics software had to be slightly modified to work with the snaptools program. These scripts will remove the header from the fragments file and compress it to be able to input into the snaptools program.

<br>

>'snap_pre_tea_seq_sample_\*.sh'

These scripts initialize the snap objects with snaptools.

<br>

## 2. Creating the peak by cell matrix

>'add_pmat_to_snap_\*.sh'

These scripts used snaptools to create the peak by cell matrix. So we took the merged pseudobulk cluster specific peak set and counted the fragments for each cell that overlap with those peaks to a matrix. If a peak by cell matrix is already in the snap object, you have to use the `snaptools snap-del` command to first remove the existing peak by cell matrix before you can add a new peak by cell matrix with the `snaptools snap-add-pmat` command.

<br>

## 3. Pseudobulk accessibility profiles for clusters

>'pull_out_pmat_from_snap_objects.ipynb'

This script was used to pull out the peak by cell matrices from the snap objects and save them as separate sparse .mtx files.

<br>

>'create_centroids_from_pmats.ipynb'

This script takes the peak by cell matrix, the cluster labels identified by the modified pyHarmony label transfer from the CITE-seq reference to the TEA-seq data, and creates pseudobulk accessibility profiles to work with downstream.

<br><br>

# VII. Correlate peaks to genes

*Directory for these scripts:*

>'4-TEA-seq/pseudobulk_accessibility_processing/correlate_peaks_to_genes/'

## 1. Calculate peak to gene correlations within TADs

>'expressed_genes_to_peaks_within_tads_correlations.ipynb'

The purpose of this script is to correlate the accessibility of peaks to the expression of 

<br>

## 2. Visualize peak to gene correlations





<br><br><br><br><br><br><br><br><br><br><br><br><br>

# XXXX. HEADER

## 1. TITLE1 

***''***

EXPLANATIONNNNNNNN

<br>

## 2. TITLE2 

***''***

EXPLANATIONNNNNNNN

<br><br>



***''***
***''***
***''***
***''***
