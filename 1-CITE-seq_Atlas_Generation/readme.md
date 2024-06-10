# 1-CITE-seq Atlas Generation

Here, we describe the code used to create the CITE-seq Atlas.

<br>

## Outline

[1-CITE-seq Atlas Generation](#1-cite-seq-atlas-generation)

<div style="padding-left: 40px;">

[I. Initial data processing](#i-initial-data-processing)

- [1. Process Fluidigm data](#1-process-fluidigm-data)
- [2. cellranger count for CITE-seq](#2-cellranger-count-for-cite-seq)
- [3. Removal of ambient RNA with soupx](#3-removal-of-ambient-rna-with-soupx)

<br>

[II. ADT Processing](#ii-adt-processing)

- [1. Denoising ADT values with TotalVI](#1-denoising-adt-values-with-totalvi)

<br>

[III. scTriangulate](#iii-sctriangulate)

<br>

[IV. Downstream analysis of CITE-seq data](#iv-downstream-analysis-of-cite-seq-data)

- [1. Integrated RNA-seq UMAP](#1-integrated-rna-seq-umap)
- [2. Gene and ADT Markers for each cluster](#2-gene-and-adt-markers-for-each-cluster)

</div>

<br><br>

# I. Initial data processing

## 1. Process Fluidigm data

Prior to the CITE-seq atlas generation, we used exploratory flow cytometry panel development to try to narrow down sorting strategies to enrich for previous definitions of MultiLineage cells (Olsson et al., Nature, 2016). These sorted cells were captured with Fluidigm single-cell RNA sequencing technology and processed as described below.

<br>

>['ExtDataFig_1d/process_fluidigm_data.sh'](ExtDataFig_1d/process_fluidigm_data.sh)

The command in this script quantified the normalized read counts for the populations.

<br>

>['ExtDataFig_1d/fluidigm_cellharmony_analysis.sh'](ExtDataFig_1d/fluidigm_cellharmony_analysis.sh)

The command in this script transfers labels from the reference RNA-seq dataset to this Fluidigm data.

<br>

## 2. cellranger count for CITE-seq

>['Fig_1a/cellranger_cite_seq_samples.sh'](Fig_1a/cellranger_cite_seq_samples.sh)

See this script for running 10X cellranger on the CITE-seq data. The example supplementary files can be found [here](Fig_1a/cellranger_cite_seq_samples-example_files).

<br>

## 3. Removal of ambient RNA with soupx

>['Fig_1a/run_soupx_on_cite_seq_transcriptome_data.R'](Fig_1a/run_soupx_on_cite_seq_transcriptome_data.R)

For all 10X Genomics scRNA-seq experiments, ambient RNA was removed using the soupx algorithm. The above script provides an example.

<br><br>

# II. ADT Processing

## 1. Denoising ADT values with TotalVI

>['Fig_1a/run_totalvi_on_cite_seq_data.py'](Fig_1a/run_totalvi_on_cite_seq_data.py)

There is an incredible amount of noise in ADT signals generated from CITE-seq. We find that they are almost unusable for downstream tasks without any denoising. Here we use TotalVI, a variational autoencoder approach, to denoise the ADT values.

<br><br>

# III. scTriangulate

There are many different ways to assign clusters to single-cell omics datasets. For example, people arbitrarily assign different "resolution"-type parameter values to control the degree which the data is split into different clusters. We also want to take into account prior clustering solutions. Although it doesn't actually solve the problem of picking the best resolution, scTriangulate does give us a way to score how well different clustering solutions describe the data. Here, we applied it to take in different Leiden clustering resolutions on both the RNA and ADT values, as well as prior RNA-seq reference annotations of mouse bone marrow data.

<br>

>['Fig_1g/preprocess_cite_seq_data_for_sctriangulate_input.sh'](Fig_1g/preprocess_cite_seq_data_for_sctriangulate_input.sh)

This script is used to prepare the data for scTriangulate. The following annotation file provides the relevant UMAP coordinates of RNA, ADT, and Reference based analyses prior to scTriangulate: ['sctriangulate_input_components_table.csv'](Fig_1g/sctriangulate_input_components_table.csv).

<br>

>['Fig_1g/run_scTriangulate_titrated_clean.py'](Fig_1g/run_scTriangulate_titrated_clean.py)

This script runs scTriangulate. 

<br>

>['ExtDataFig_2d-g/plot_sctriangulate_metrics.ipynb'](ExtDataFig_2d-g/plot_sctriangulate_metrics.ipynb)

This script was used to plot the scTriangulate metrics over the integrated UMAP. The output annotations used to plot scTriangulate metrics can be found here: ['ExtDataFig_2d-g/sctriangulate_metrics_and_umap_coordinates.csv'](ExtDataFig_2d-g/sctriangulate_metrics_and_umap_coordinates.csv).

<br><br>

# IV. Downstream analysis of CITE-seq data

## 1. Integrated RNA-seq UMAP

>['Fig_1g/HIVE_and_10X_Genomics_Integrated_UMAP_Embedding.R'](Fig_1g/HIVE_and_10X_Genomics_Integrated_UMAP_Embedding.R)

Seurate was used to create the integrated RNA-seq UMAP. The resulting integrated UMAP coordinates for each relevant scRNA-seq dataset can be found here: ['Fig_1g/integrated_umap_coordinates'](Fig_1g/integrated_umap_coordinates).

<br>

>['ExtDataFig_2d-g/plot_captured_populations_over_integrated_RNA_umap_embedding.ipynb'](ExtDataFig_2d-g/plot_captured_populations_over_integrated_RNA_umap_embedding.ipynb)

This script was used to plot cell populations over the integrated RNA-seq UMAP

<br><br>

## 2. Gene and ADT Markers for each cluster

>['Fig_1h/identify_markers_and_generate_heatmaps.ipynb'](Fig_1h/identify_markers_and_generate_heatmaps.ipynb)

Here, we identified marker genes and marker ADTs for the 87 cluster populations using markerFinder, and plotted those markers as heatmaps.

<a href="#outline" style="display: block; position: fixed; bottom: 20px; right: 20px; padding: 10px; background-color: #333; color: #fff; text-decoration: none; z-index: 9999;">Back to Outline</a>
