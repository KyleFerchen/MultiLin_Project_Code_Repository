'''
!!!! Script to filter a bam file based on cluster after bam file generated from 10X Genomics cellranger atac
Notes:
- Must load python version 3.6.3 on the CCHMC HPC
'''
import pysam
import pandas as pd
import os
import sys

usage_statement = """
		    Usage:
		      python general_filter_bam_file_with_cell_annotation.py <path_cell_anno> <pathToBamFile> <path_output_files>
			  where:
			      <path_cell_anno> : the path to the annotation file, with a header naming columns in a tab
						delimited file for cell barcode id in the first column and cluster name in the
						second column (Ex. /users/fero3l/sc_atac_seurat/seurat_3531_atac_with_icgs_cell_predictions.txt)
			      <pathToBamFile> : the path to the original bam file to split 
						(Ex. /data/salomonis2/Grimes/DNA/10X-ATAC/10X-ATAC-Muench-Nature/10X-Grimes-3531-20190308-ATACv1mm-1.0.1/outs/possorted_bam.bam)
			      <path_output_files> : the directory to save the files, which must already exist
						    (Ex. /data/salomonis2/LabFiles/Kyle/Analysis/output_bam_splits)
		  		 	"""

if len(sys.argv) != 4:
    print(usage_statement)

# Paths
path_cell_anno = sys.argv[1]
pathToBamFile = sys.argv[2]
path_output_files = sys.argv[3]

# Read in the cluster file
cell_anno = pd.read_csv(path_cell_anno,sep='\t')
cell_anno.iloc[:,1] = cell_anno.iloc[:,1].astype(str)
unique_clusters = list(set(list(cell_anno.iloc[:,1])))
cells_per_cluster = cell_anno.iloc[:,1].value_counts().to_dict()

# Start reading the bam file to split
samfile = pysam.AlignmentFile(pathToBamFile,"rb")

# Create dictionary of cell barcode to cluster
cell_anno_dict =  {}
for i in range(1,cell_anno.shape[0]):
    cell_anno_dict[cell_anno.iloc[i,0]] = cell_anno.iloc[i,1]

# Create a dictionary of alignment files
output_files = {}
for cluster in unique_clusters:
    # Translate the cluster name to one that can be used in a file name
    transTable = {'/':'_','-':'_'}
    cluster_file_name = cluster.translate(str.maketrans(transTable))
    tmp_file_name = os.path.join(path_output_files,"cluster_"+cluster_file_name+"_bam_split.bam")
    output_files[cluster] = pysam.AlignmentFile(tmp_file_name, "wb", template=samfile)

# Create a dictionary to keep track of the number of reads in a cluster
track_cluster_reads = {}
for cluster in unique_clusters:
    track_cluster_reads[cluster] = 0

# Loop through reads in the bam file and allocate to new files based on cluster
for read in samfile.fetch():
	if read.has_tag('CB'):
		tmp_barcode = read.get_tag('CB')
		if tmp_barcode in cell_anno_dict:
			tmp_cluster = cell_anno_dict[tmp_barcode]
			output_files[tmp_cluster].write(read)
			track_cluster_reads[tmp_cluster] += 1

# Write out counting metrics
metrics = pd.DataFrame([cells_per_cluster, track_cluster_reads], index=["cells_per_cluster", "reads_per_cluster"]).T
metrics_file_path = os.path.join(path_output_files, "metrics_bam_cluster_splits.txt")
metrics.to_csv(metrics_file_path, sep="\t", index_label="cluster")

# Close all of the output alignment files
for cluster in output_files:
    output_files[cluster].close()

# Close the original bam file
samfile.close()