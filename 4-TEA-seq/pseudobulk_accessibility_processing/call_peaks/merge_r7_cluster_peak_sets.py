
# module load python3/3.6.3
import os
import pandas as pd
import numpy as np
import re
import time

###############################################################################
# Requires Input
###############################################################################

os.chdir("/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/")
path_merged_peak_output = "output/tea_r7_macs2_p_0_05_merged_peak_set/r7_tea_p_0_05_merged_peaks.bed"
path_peak_summits = "output/tea_r7_merged_peak_calling_p_0_05/summits/"
chromosomes_to_use = ["chr1", "chr2", "chr3", "chr4", "chr5",
		      "chr6", "chr7", "chr8", "chr9", "chr10",
		      "chr11", "chr12", "chr13", "chr14", "chr15",
		      "chr16", "chr17", "chr18", "chr19", "chr20",
		      "chr21", "chr22", "chrX", "chrY"]

# The desired size of the output peaks (bp)
set_peak_length = 1000

tmp_directory = "XXX_tmp_directory_XXX"

###############################################################################
# Analysis
###############################################################################
os.mkdir(tmp_directory)

summits_sname_re = re.compile(r'(.+)_summits\.bed')

print("Reading and splitting peak files by chromosome...")
track_chr_files_created = []
peak_files_list = np.array(os.listdir(path_peak_summits))

for tmp_file in peak_files_list:
  print("Reading in {}".format(tmp_file))
  sample_name = summits_sname_re.findall(tmp_file)[0]
  tmp_peaks = pd.read_table(os.path.join(path_peak_summits, tmp_file), header=None)
  unique_chr = tmp_peaks.iloc[:,0].unique()
  chr_space = np.intersect1d(chromosomes_to_use, unique_chr)
  for tmp_chr in chr_space:
    tmp_subset = tmp_peaks.loc[tmp_peaks.iloc[:,0] == tmp_chr].iloc[:,[0,1,2,4]]
    print("\t{} ... {} peaks exist...".format(tmp_chr, tmp_subset.shape[0]))
    tmp_chr_file_path = os.path.join(tmp_directory, "{}.bed".format(tmp_chr))
    tmp_subset["sample"] = sample_name
    if os.path.exists(tmp_chr_file_path):
      tmp_set_mode = "a"
    else:
      tmp_set_mode = "w"
    tmp_subset.iloc[:,[0,1,4,3]].to_csv(tmp_chr_file_path, mode=tmp_set_mode, sep="\t", index=False, header=False)

print("Done separating peaks.")
print("Working on selecting significant peaks with given distance criteria...")

chr_files = os.listdir(tmp_directory)
saved_chr_peaks = {}
for tmp_chr_file in chr_files:
  print("Working on {}...".format(tmp_chr_file))
  tmp_peaks = pd.read_table(os.path.join(tmp_directory, tmp_chr_file), header=None)
  tmp_peaks.columns = ["chr", "start", "replicate", "significance"]
  tmp_peaks = tmp_peaks.sort_values(by="significance", ascending=False)
  tmp_peaks.index = list(range(tmp_peaks.shape[0]))
  subset_starts = tmp_peaks.iloc[:,1].values
  saved_starts = []
  while subset_starts.shape[0] > 0:
    saved_starts.append(subset_starts[0])
    subset_starts = subset_starts[np.abs(subset_starts - subset_starts[0]) > set_peak_length]
    print("{} indices remaining...".format(subset_starts.shape[0]))
  tmp_peaks = tmp_peaks.loc[tmp_peaks["start"].isin(saved_starts)]
  saved_chr_peaks[tmp_chr_file.split(".")[0]] = tmp_peaks.loc[~tmp_peaks["start"].duplicated().values]
  
 
print("Done selecting significant peaks. Writing out merged results...")
merged_bed = []
for item in saved_chr_peaks:
  merged_bed.append(saved_chr_peaks[item])

merged_bed = pd.concat(merged_bed)
merged_bed["end"] = merged_bed["start"] + 500
merged_bed["start"] = merged_bed["start"] - 500
merged_bed = merged_bed.sort_values(by=["chr", "start"])
merged_bed.to_csv(path_merged_peak_output, sep="\t", header=False, index=False)

print("Done.")

"""
start = time.time()

for i, row in summits.iterrows():
    if (i % 100000) == 0:
        print(i)
        print("\tAfter {} s...".format(time.time() - start))
    if len(sel_starts[row["chr"]]) > 0:
        if min(abs(sel_starts[row["chr"]] - row["start"])) > 500:
            sel_starts[row["chr"]] = np.append(sel_starts[row["chr"]], [row["start"]])
    else:
        sel_starts[row["chr"]] = np.append(sel_starts[row["chr"]], [row["start"]])

"""




# The old way:

# import pandas as pd
# import numpy as np
# import os
# import time

# ###############################################################################
# # Requires Input
# ###############################################################################
# os.chdir("/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/")

# # Note: have to move summits files into their own directory specified below
# path_to_macs2_callpeaks_output = "output/tea_r7_merged_peak_calling_p_0_05/summits/"
# # Delete irrelevant MACS2 outputs to save space

# # Directory to save the final merged peak sets
# path_output_peaks = "output/tea_r7_macs2_p_0_05_merged_peak_set/"

# # Define prefix for output bed files
# output_prefix = "r7_tea_p_0_05_"


# ###############################################################################
# # Analysis
# ###############################################################################
# unique_samples = np.unique(["_".join(item.split("_")[:-1]) for item in os.listdir(path_to_macs2_callpeaks_output)])


# summits = pd.concat([pd.read_table(os.path.join(path_to_macs2_callpeaks_output, "{}_summits.bed".format(item)), header=None) for item in unique_samples])
# summits.columns = ["chr", "start", "end", "name", "significance"]
# summits = summits.sort_values(by="significance", ascending=False)


# summits.index = list(range(summits.shape[0]))
# sel_starts = {}
# for item in summits["chr"].unique():
#     sel_starts[item] = np.array([])

# start = time.time()
# for i, row in summits.iterrows():
#     if (i % 100000) == 0:
#         print(i)
#         print("\tAfter {} s...".format(time.time() - start))
#     if len(sel_starts[row["chr"]]) > 0:
#         if min(abs(sel_starts[row["chr"]] - row["start"])) > 500:
#             sel_starts[row["chr"]] = np.append(sel_starts[row["chr"]], [row["start"]])
#     else:
#         sel_starts[row["chr"]] = np.append(sel_starts[row["chr"]], [row["start"]])


# merged_peaks = {"chr": np.array([]),
#                 "start": np.array([]),
#                 "end": np.array([])}
# for tmp_chr in sel_starts:
#     merged_peaks["chr"] = np.append(merged_peaks["chr"], [tmp_chr]*len(sel_starts[tmp_chr]))
#     merged_peaks["start"] = np.append(merged_peaks["start"], sel_starts[tmp_chr]-250)
#     merged_peaks["end"] = np.append(merged_peaks["end"], sel_starts[tmp_chr]+250)

# merged_peaks = pd.DataFrame(merged_peaks)
# merged_peaks["start"] = merged_peaks["start"].astype(int)
# merged_peaks["end"] = merged_peaks["end"].astype(int)

# merged_peaks.loc[merged_peaks["start"] < 0, "start"] = 0

# sel_chr = ['chr1', 'chr2', 'chr3',  'chr4', 'chr5',  'chr6', 'chr7',  'chr8', 'chr9',
#             'chr10', 'chr11', 'chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19',
#             'chr20', 'chr21', 'chr22', 'chrX', 'chrY', 'chrM']

# sel_merged_peaks = merged_peaks.loc[merged_peaks["chr"].isin(sel_chr)].copy()

# sel_merged_peaks.sort_values(\
#     by=["chr", "start"]).to_csv(\
#         os.path.join(\
#             path_output_peaks, 
#             "{}merged_peaks.bed".format(output_prefix)),
#         header=False, index=False, sep="\t")
# merged_peaks.sort_values(\
#     by=["chr", "start"]).to_csv(\
#         os.path.join(\
#             path_output_peaks, 
#             "{}merged_peaks_with_alt_chromosomes.bed".format(output_prefix)),
#         header=False, index=False, sep="\t")



