
# module load python3/3.7.1

import os
import pandas as pd
import numpy as np
from scipy.io import mmread
from scipy.sparse import vstack
from scipy.io import mmwrite
import gc

working_dir = "/data/salomonis2/LabFiles/Kyle/Analysis/2022_07_07_tea_seq_atac_processing/"
os.chdir(working_dir)


def helper_load_sparse_mtx_from_dir(input_dir, exp_name):
  print("Reading sparse matrix for {}...".format(exp_name))
  tmp_sparse_mtx = mmread(os.path.join(input_dir, "binary_pmat.mtx"))
  tmp_barcodes = pd.read_table(os.path.join(input_dir, "barcodes.tsv"), header=None).iloc[:,0].values
  tmp_peaks = pd.read_table(os.path.join(input_dir, "peaks.tsv"), header=None).iloc[:,0].values
  print("Output is dictionary with the following keys: 'sparse_mtx', 'barcodes', 'peaks'")
  return({"sparse_mtx": tmp_sparse_mtx,
	  "barcodes": [exp_name + ":" + item for item in tmp_barcodes],
	  "peaks": tmp_peaks})



ml1 = helper_load_sparse_mtx_from_dir("output/tea_seq_split_bams/r7_nathan_frank/merged_cluster_peaks_macs2_p_0_05_pmats_2022_07_20/ML1/",
				      exp_name="ML1")
ml2 = helper_load_sparse_mtx_from_dir("output/tea_seq_split_bams/r7_nathan_frank/merged_cluster_peaks_macs2_p_0_05_pmats_2022_07_20/ML2/",
				      exp_name="ML2")
h1 = helper_load_sparse_mtx_from_dir("output/tea_seq_split_bams/r7_nathan_frank/merged_cluster_peaks_macs2_p_0_05_pmats_2022_07_20/H1/",
				      exp_name="H1")
h2 = helper_load_sparse_mtx_from_dir("output/tea_seq_split_bams/r7_nathan_frank/merged_cluster_peaks_macs2_p_0_05_pmats_2022_07_20/H2/",
				      exp_name="H2")

print("Shape of ML1 sparse matrix: {}".format(ml1["sparse_mtx"].shape))
print("Shape of ML2 sparse matrix: {}".format(ml2["sparse_mtx"].shape))
print("Shape of H1 sparse matrix: {}".format(h1["sparse_mtx"].shape))
print("Shape of H2 sparse matrix: {}".format(h2["sparse_mtx"].shape))

combined = vstack([ml1["sparse_mtx"], ml2["sparse_mtx"], h1["sparse_mtx"], h2["sparse_mtx"]])
combined_barcodes = pd.Series(list(ml1["barcodes"]) + list(ml2["barcodes"]) + list(h1["barcodes"]) + list(h2["barcodes"]))

# Write the output files
path_output = "output/tea_seq_split_bams/r7_nathan_frank/merged_cluster_peaks_macs2_p_0_05_pmats_2022_07_20/combined/"
if not os.path.isdir(path_output):
  os.mkdir(path_output)

combined_barcodes.to_csv(os.path.join(path_output, "barcodes.tsv"), sep="\t", header=False, index=False)
pd.Series(ml1["peaks"]).to_csv(os.path.join(path_output, "peaks.tsv"), sep="\t", header=False, index=False)
mmwrite(os.path.join(path_output, "binary_pmat.mtx"), combined)