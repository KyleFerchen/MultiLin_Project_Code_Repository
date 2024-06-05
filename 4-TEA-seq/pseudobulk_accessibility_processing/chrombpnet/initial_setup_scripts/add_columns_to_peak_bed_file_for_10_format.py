
import os
import pandas as pd

os.chdir("/data/salomonis2/LabFiles/Kyle/Analysis/"\
    "2023_06_12_tea_seq_atac_processing/output/chrombpnet/peaks/")

# Chrombpnet oddly expects a 10 column format
# Columns 1-6 seem to follow the conventional BED format (as described here:
# https://genome.ucsc.edu/FAQ/FAQformat.html)
#
# However, it is not clear what columns 7-10 mean in chrombpnet examples
#
# For my peak set, I'll follow the UCSC listed bed format above, but for column
# 10, I'll use the value needed by chrombpnet, which should be the summit 
# position. This seems to be relative to the start position.
# Since all of my peaks are centered on summits and extended +/-500 bp,
# I'll simply add the value 500 for the 10th column value

peaks = pd.read_table("peaks_no_blacklist.bed", header=None)

peaks.columns = ["chr", "start", "end", "name", "score", "strand"]
peaks["thickStart"] = peaks["start"]
peaks["thickEnd"] = peaks["end"]
peaks["itemRgb"] = "84,0,168"
peaks["summit"] = 500

peaks.to_csv("peaks_no_blacklist_10_column_format.bed",
    sep="\t", header=False, index=False)

# 1 - chrom - The name of the chromosome (e.g. chr3, chrY, chr2_random) or 
#       scaffold (e.g. scaffold10671). 
# 2 - chromStart - The starting position of the feature in the chromosome or 
#       scaffold. The first base in a chromosome is numbered 0.
# 3 - chromEnd - The ending position of the feature in the chromosome or 
#       scaffold. The chromEnd base is not included in the display of the 
#       feature, however, the number in position format will be represented. 
#       For example, the first 100 bases of chromosome 1 are defined as chrom=1, 
#       chromStart=0, chromEnd=100, and span the bases numbered 0-99 in our 
#       software (not 0-100), but will represent the position notation 
#       chr1:1-100. Read more here.
#       chromStart and chromEnd can be identical, creating a feature of length 
#       0, commonly used for insertions. For example, use chromStart=0, 
#       chromEnd=0 to represent an insertion before the first nucleotide of a 
#       chromosome.
# 4 - name - Defines the name of the BED line. This label is displayed to the 
#       left of the BED line in the Genome Browser window when the track is 
#       open to full display mode or directly to the left of the item in pack 
#       mode.
# 5 - score - A score between 0 and 1000. If the track line useScore attribute 
#       is set to 1 for this annotation data set, the score value will 
#       determine the level of gray in which this feature is displayed (higher 
#       numbers = darker gray). 
# 6 - strand - Defines the strand. Either "." (=no strand) or "+" or "-".
# 7 - thickStart - The starting position at which the feature is drawn thickly 
#       (for example, the start codon in gene displays). When there is no thick 
#       part, thickStart and thickEnd are usually set to the chromStart position.
# 8 - thickEnd - The ending position at which the feature is drawn thickly 
#       (for example the stop codon in gene displays).
# 9 - itemRgb - An RGB value of the form R,G,B (e.g. 255,0,0). If the track 
#       line itemRgb attribute is set to "On", this RBG value will determine 
#       the display color of the data contained in this BED line. 
#       NOTE: It is recommended that a simple color scheme (eight colors or 
#       less) be used with this attribute to avoid overwhelming the color 
#       resources of the Genome Browser and your Internet browser.
# 10 - summit - The summit position relative to the chromStart

