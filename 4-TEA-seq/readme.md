

# 4-TEA-seq

In this study, TEA-seq was performed on 2 samples:

1. HSC/MPP gated cells
2. MultiLin gated cells

These populations enrich for the hematopoietic stem cells, the multilineage progenitor populations, and the immediate specification events to unipotent lineages, thought to go through hierarchical lineage restriction.

*Note: although TEA-seq captures surface protein, transcriptomes, and accessibility data, we found that the surface protein data and transcriptome data was not as robust as that obtained from CITE-seq and InfinityFlow. So we prioritized our efforts to map states between CITE-seq and TEA-seq and use the RNA from CITE-seq and the ATAC-based accessibility from TEA-seq for downstream analyses.*

<br>

## Outline
[4-TEA-seq](#4-tea-seq)

[I. Initial TEA-seq processing](#i-initial-tea-seq-processing)

- [1. cellranger count](#1-cellranger-count)

[II. CITE-seq Label Transfer to TEA-seq Data](#ii-cite-seq-label-transfer-to-tea-seq-data)

- [1. Label transfer using modified pyHarmony algorithm](#1-label-transfer-using-modified-pyharmony-algorithm)
- [2. Validation of label transfer](#2-validation-of-label-transfer)

[III. Pseudobulk processing of accessibility data](#iii-pseudobulk-processing-of-accessibility-data)

- [1. Split BAM files to TEA-seq cluster annotations ](#1-split-bam-files-to-tea-seq-cluster-annotations)
- [2. Sort and merge split bams by clusters](#2-sort-and-merge-split-bams-by-clusters)

[IV. Call peaks on TEA-seq pseudobulk clusters](#iv-call-peaks-on-tea-seq-pseudobulk-clusters)

- [1. Use individual pseudobulk cluster BAM files to call peaks](#1-use-individual-pseudobulk-cluster-bam-files-to-call-peaks)
- [2. Merge the peak sets called on individual clusters](#2-merge-the-peak-sets-called-on-individual-clusters)

[V. Create BigWig files](#v-create-bigwig-files)

[VI. Peak by cell matrix and pseudobulk profiles](#vi-peak-by-cell-matrix-and-pseudobulk-profiles)

- [1. Set up the snap objects](#1-set-up-the-snap-objects)
- [2. Creating the peak by cell matrix](#2-creating-the-peak-by-cell-matrix)
- [3. Pseudobulk accessibility profiles for clusters](#3-pseudobulk-accessibility-profiles-for-clusters)

[VII. Correlate peaks to genes](#vii-correlate-peaks-to-genes)

- [1. Calculate peak to gene correlations within TADs](#1-calculate-peak-to-gene-correlations-within-tads)
- [2. Visualize peak to gene correlations]()

[VIII. ChromBPNet](#viii-chrombpnet)

- [1. Initial setup for ChromBPNet](#1-initial-setup-for-chrombpnet)
- [2. Model training for ChromBPNet](#2-model-training-for-chrombpnet)
- [3. Base resolution contribution score predictions](#3-base-resolution-contribution-score-predictions)
- [4. Seqlet pattern clustering with tfmodisco](#4-seqlet-pattern-clustering-with-tfmodisco)











<br><br>

# I. Initial TEA-seq processing

## 1. cellranger count

>['cellranger.sh'](cellranger_example/cellranger.sh)

The fastq files after sequencing were processed using the cellranger count program (v5.0.1) with the `--chemistry=ARC-v1`

Eg.:

```shell
cellranger count --id=$INPUTFILE  --libraries=library.csv --transcriptome=/database/cellranger/$SPECIESDATABASE  --feature-ref=Mouse-ADT-Custom.csv  --localmem 132   --include-introns  --chemistry=ARC-v1
```

<br><br>

# II. CITE-seq Label Transfer to TEA-seq Data

## 1. Label transfer using modified pyHarmony algorithm

>['CITE-seq_to_TEA-seq_Label_Transfer.ipynb'](CITE-seq_to_TEA-seq_Label_Transfer/CITE-seq_to_TEA-seq_Label_Transfer.ipynb)

This notebook walks through the pyHarmony method used to correct for batch effects between CITE-seq and TEA-seq transcriptomes and to transfer the labels from the CITE-seq reference to the TEA-seq cells.

<br>

## 2. Validation of label transfer

>['Validation_of_Label_Transfer.ipynb'](CITE-seq_to_TEA-seq_Label_Transfer/Validation_of_Label_Transfer.ipynb)

The label transfer from CITE-seq to TEA-seq is validated by comparing the ranking of marker genes according to gene expression data from both modalities. A spearman correlation value between ranking of top marker genes is compared between each cluster between modalities.

<br><br>

# III. Pseudobulk processing of accessibility data

## 1. Split BAM files to TEA-seq cluster annotations 

>['Splitting_BAM_Files_to_Pseudobulk_Clusters/split_bam_\*.sh'](pseudobulk_accessibility_processing/Splitting_BAM_Files_to_Pseudobulk_Clusters/split_bam_H1_tea_r7.sh)

Each of these *.sh* files split the possorted BAM file from cellranger into pseudobulk BAM files.

<br>

## 2. Sort and merge split bams by clusters

>['sort_and_index_\*_bams.sh'](pseudobulk_accessibility_processing/sort_and_merge_pseudobulk_bam_files/sort_and_index_h1_bams.sh)

After the BAM files are separated by clusters, these scripts sort and index the BAM files.

<br>

>['merge_r7_bams_h_and_m_\*.sh'](pseudobulk_accessibility_processing/sort_and_merge_pseudobulk_bam_files/merge_r7_bams_h_and_m_01.sh)

These scripts merge the BAM files for each cluster.

<br>

>['index_merged_sorted_bams_\*.sh'](pseudobulk_accessibility_processing/sort_and_merge_pseudobulk_bam_files/index_merged_sorted_bams_1.sh)

These scripts index the cluster BAM files after they were merged.

<br><br>

# IV. Call peaks on TEA-seq pseudobulk clusters

## 1. Use individual pseudobulk cluster BAM files to call peaks

>['call_peaks/merged_macs2_callpeak_p_0_05_set_\*.sh'](pseudobulk_accessibility_processing/call_peaks/merged_macs2_callpeak_p_0_05_set_01.sh)

These files are used to call peaks on the cluster split BAM files.

<br>

## 2. Merge the peak sets called on individual clusters

>['call_peaks/merge_r7_cluster_peak_sets.py'](pseudobulk_accessibility_processing/call_peaks/merge_r7_cluster_peak_sets.py)

This file merges the peak summits. The algorithm orders the summits called by MACS2 by their significance, and then iteratively removes less significant summits that are within a predefined range (+/- 500 bp).

<br><br>

# V. Create BigWig files

>['create_bigwig_files/merged_get_bigwig_set_\*.sh'](pseudobulk_accessibility_processing/create_bigwig_files/merged_get_bigwig_set_01.sh)

The BigWig files created with the scripts in this directory are used to project the accessibility coverage tracks onto a genome browser.

<br><br>

# VI. Peak by cell matrix and pseudobulk profiles

*Directory for these scripts:*

>'4-TEA-seq/pseudobulk_accessibility_processing/snaptools/'

After peaks have been identified (within individual pseudobulk clusters), we want to represent the single-cell accessibility data from TEA-seq as a peak by cell matrix. This quickly enables downstream analysis of those peaks. Here we use the snaptools program to generate the peak by cell matrix.

## 1. Set up the snap objects

>['prep_tea_seq_sample_\*.sh'](pseudobulk_accessibility_processing/snaptools/prep_tea_seq_sample_01.sh)

First, the output from the 10X genomics software had to be slightly modified to work with the snaptools program. These scripts will remove the header from the fragments file and compress it to be able to input into the snaptools program.

<br>

>['snap_pre_tea_seq_sample_\*.sh'](pseudobulk_accessibility_processing/snaptools/snap_pre_tea_seq_sample_01.sh)

These scripts initialize the snap objects with snaptools.

<br>

## 2. Creating the peak by cell matrix

>['add_pmat_to_snap_\*.sh'](pseudobulk_accessibility_processing/snaptools/add_pmat_to_snap_h1.sh)

These scripts used snaptools to create the peak by cell matrix. So we took the merged pseudobulk cluster specific peak set and counted the fragments for each cell that overlap with those peaks to a matrix. If a peak by cell matrix is already in the snap object, you have to use the `snaptools snap-del` command to first remove the existing peak by cell matrix before you can add a new peak by cell matrix with the `snaptools snap-add-pmat` command.

<br>

## 3. Pseudobulk accessibility profiles for clusters

>['pull_out_pmat_from_snap_objects.ipynb'](pseudobulk_accessibility_processing/snaptools/pull_out_pmat_from_snap_objects.ipynb)

This script was used to pull out the peak by cell matrices from the snap objects and save them as separate sparse .mtx files.

<br>

>['create_centroids_from_pmats.ipynb'](pseudobulk_accessibility_processing/snaptools/create_centroids_from_pmats.ipynb)

This script takes the peak by cell matrix, the cluster labels identified by the modified pyHarmony label transfer from the CITE-seq reference to the TEA-seq data, and creates pseudobulk accessibility profiles to work with downstream.

<br><br>

# VII. Correlate peaks to genes

*Directory for these scripts:*

>'4-TEA-seq/pseudobulk_accessibility_processing/correlate_peaks_to_genes/'

## 1. Calculate peak to gene correlations within TADs

>['expressed_genes_to_peaks_within_tads_correlations.ipynb'](pseudobulk_accessibility_processing/correlate_peaks_to_genes/expressed_genes_to_peaks_within_tads_correlations.ipynb)

The purpose of this script is to correlate the accessibility of peaks to the expression of genes. These comparisons are restricted to be within pre-defined TADs (identified by Chen et al. Cell Reports 2019 : GSE119347). We can then restrict the peak set to those that correlate to changes in gene expression above a pre-defined level (any peak with a p-value < 0.001 from Pearson correlation test).

<br>

## 2. Visualize peak to gene correlations

>['cluster_peak_and_gene_correlations_with_significant_connections.ipynb'](pseudobulk_accessibility_processing/correlate_peaks_to_genes/cluster_peak_and_gene_correlations_with_significant_connections.ipynb)

Here we use hierarchical clustering of the peak by gene correlation values to group genes that have similar peak correlation profiles. These clusters of genes can be thought to be regulated by similar groups of peaks.

<br><br>

# VIII. ChromBPNet

>***'pseudobulk_accessibility_processing/chrombpnet/'***

In this study, ChromBPNet was run on the pseudobulk accessibility profiles to generate models that predict accessibility profiles by training on DNA sequences. These provide a context-specific prediction for what DNA syntax elements are important for predicting increased chromatin accessibility. This is paired with tfmodisco to identify DNA motifs that are important for predicting accessibility.

## 1. Initial setup for ChromBPNet

>['initial_setup_scripts/add_columns_to_peak_bed_file_for_10_format.py'](pseudobulk_accessibility_processing/chrombpnet/initial_setup_scripts/add_columns_to_peak_bed_file_for_10_format.py)

ChromBPNet uses a 10 column format for the peak set. This script reformats the merged peak set identified above.

<br>

>['initial_setup_scripts/prepare_chr_splits.sh'](pseudobulk_accessibility_processing/chrombpnet/initial_setup_scripts/prepare_chr_splits.sh)

This script prepares the cross validation regions. These are sets of chromosomes that split the peak set into regions used for training the model and regions used for validating the model.

<br>

>['initial_setup_scripts/prepare_non_blacklist_peak_set.sh'](pseudobulk_accessibility_processing/chrombpnet/initial_setup_scripts/prepare_non_blacklist_peak_set.sh)

This script filters the peak set to remove blacklisted regions.

<br>

>['initial_setup_scripts/prepare_non_peak_regions_for_splits.sh'](pseudobulk_accessibility_processing/chrombpnet/initial_setup_scripts/prepare_non_peak_regions_for_splits.sh)

This script prepares the non-peak regions. These are regions used to train the bias model to learn DNA syntax that is preferentially bound by the Tn5 enzyme.

<br><br>

## 2. Model training for ChromBPNet

>['model_training/train_bias_model_ml1_fold_0.sh'](pseudobulk_accessibility_processing/chrombpnet/model_training/train_bias_model_ml1_fold_0.sh)

Trains the bias model. Note that one of the possorted BAM files from 10X cellranger is used. This contains enough cells from different types to try to avoid having the bias model learn a cell type specific sequence incorrectly as Tn5 bias.

<br>

>['model_training/cluster_specific_models/train_\*_test_fold_0.sh'](pseudobulk_accessibility_processing/chrombpnet/model_training/cluster_specific_models/train_alphaLP_test_fold_0.sh)

These files train the ChromBPNet models for each pseudobulk cluster accessibility file.

<br>

## 3. Base resolution contribution score predictions

>['predict_contribution_score_bw/contribs_bw_\*_fold_0.sh'](pseudobulk_accessibility_processing/chrombpnet/predict_contribution_score_bw/contribs_bw_BMCP_fold_0.sh)

Each of these script files calculates the base resolution contribution score values for the pseudobulk models.

<br>

## 4. Seqlet pattern clustering with tfmodisco

>['tfmodisco/tfmodisco_lite_\*.sh'](pseudobulk_accessibility_processing/chrombpnet/tfmodisco/tfmodisco_lite_BMCP.sh)

Each of these script files identifies CWM patterns for each of the contribution score value bigwig files. These patterns are used downstream to identify all seqlet positions in the peak set.

<br><br>


# IX. Downstream analysis of seqlets

## 1. Scanning CWM patterns across all peaks

>['seqlet_analysis/gimmemotifs_scan_modisco_patterns_for_all_peaks.ipynb'](seqlet_analysis/gimmemotifs_scan_modisco_patterns_for_all_peaks.ipynb)

The output of tfmodisco is only a subset of all the potential seqlets that could be found from the contribution score files. To search for all seqlet sites that match a CWM pattern, here we implement a custom script to scan for the DNA sequence that matches each of the CWM patterns identified by tfmodisco.

<br>

## 2. Score seqlet patterns

>['seqlet_analysis/score_called_modisco_seqlets_in_all_peaks.ipynb'](seqlet_analysis/score_called_modisco_seqlets_in_all_peaks.ipynb)

After identifying sites in all peaks that match CWM DNA sequence patterns identified by tfmodisco, we score each of them for how well they match to the CWM scores. This is a dot product between the observed contribution value and the CWM values filtered to the bases with high frequency of occurrence in the CWM motif. We then filter the called seqlets to those that have a score greater than the 5th percentile of scores from the set defined by tfmodisco. This gives us the highest scoring seqlets that match a pattern identified by tfmodisco across all queried regions.



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