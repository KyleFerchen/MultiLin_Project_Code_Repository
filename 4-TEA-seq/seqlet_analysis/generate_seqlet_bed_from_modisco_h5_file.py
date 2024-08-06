'''
Script to extract seqlet positions and save them as a bed file

Notes:
- Must load environment with ChromBPNet installed and functional
- The width appears to be constant each time modisco is run by chromBPNet 
    command. This may not necessarily always be the case
'''

usage_statement = """
    Usage:
        generate_seqlet_annotation_from_modisco_h5_file.py
            <path_h5_file> <path_peaks_file> <output_dir> <file_prefix> <width>

    Positioned arguments:

        1: <path_h5_file>: the path to the tfmodisco .h5 output file
        2: <path_peaks_file>: the path to the peaks file generated during the 
            contribution score file generation created by the "contribs_bw"
            funcion. It should have the suffix: ".interpreted_regions.bed"
        3. <output_dir>: the output directory to which to save the bed file
        4. <file_prefix>: the name you want to prefix the output file
        5. <width>: the width applied during the tfmodisco-lite motifs execution
            (probably 400, depending on the tfmodisco-lite version)

    """

import os
import sys
import pandas as pd
import numpy as np
import h5py

def map_ohe_to_seq(input_ohe):
    tmp_seq = []
    for row in input_ohe:
        bases = np.array(['A', 'C', 'G', 'T'])
        tmp_seq.append(bases[row.astype(bool)][0])
        # Try replacing with something like:
        #   bases[np.argmax(seqlet["sequence"].fwd, axis=-1)]
    
    return("".join(tmp_seq))


if __name__ == "__main__":
    if len(sys.argv) != 6:
        print(usage_statement)
        raise ValueError('Command requires four positional arguments.')

    # Paths
    path_h5_file = sys.argv[1]
    path_peaks_file = sys.argv[2]
    output_dir = sys.argv[3]
    file_prefix = sys.argv[4]
    WIDTH = int(sys.argv[5])

    adjust_start = round(WIDTH / 2) + 1

    # Load in the peaks file
    peaks = pd.read_table(path_peaks_file, header=None)

    # Extract seqlet positions from h5 file
    with h5py.File(os.path.join(path_h5_file), "r") as tmp_h5:
        saved_pos_patterns = []
        if 'pos_patterns' in list(tmp_h5):
            for tmp_pat in list(tmp_h5['pos_patterns']):
                tmp_instance = tmp_h5['pos_patterns'][tmp_pat]['seqlets']
                saved_pos_patterns.append(pd.DataFrame({\
                    "pattern": f"pos_{tmp_pat}",
                    "example_idx": tmp_instance["example_idx"][()],
                    "start": tmp_instance["start"][()],
                    "end": tmp_instance["end"][()], 
                    "is_revcomp": tmp_instance["is_revcomp"][()]}))
                
            saved_pos_patterns = pd.concat(saved_pos_patterns)

        else:
            saved_pos_patterns = pd.DataFrame()

        saved_neg_patterns = []
        if 'neg_patterns' in list(tmp_h5):
            for tmp_pat in list(tmp_h5['neg_patterns']):
                tmp_instance = tmp_h5['neg_patterns'][tmp_pat]['seqlets']
                saved_neg_patterns.append(pd.DataFrame({\
                    "pattern": f"neg_{tmp_pat}",
                    "example_idx": tmp_instance["example_idx"][()],
                    "start": tmp_instance["start"][()],
                    "end": tmp_instance["end"][()], 
                    "is_revcomp": tmp_instance["is_revcomp"][()]}))
                
            saved_neg_patterns = pd.concat(saved_neg_patterns)

        else:
            saved_neg_patterns = pd.DataFrame()

    # Build the seqlet positions
    combined_patterns = pd.concat([saved_pos_patterns, saved_neg_patterns])
    idx_vec = combined_patterns["example_idx"].values
    tmp_starts = peaks.iloc[idx_vec,[1,-1]].sum(axis=1).values - adjust_start
    seqlet_bed = pd.DataFrame({\
        "chr": peaks.iloc[idx_vec,0].values,
        "start": tmp_starts+combined_patterns["start"].values,
        "end": tmp_starts+combined_patterns["end"].values,
        "name": combined_patterns["pattern"].values,
        "score": 1000,
        "strand": combined_patterns["is_revcomp"].replace({\
            True: "-", False: "+"}).values})
    
    # Save bed file
    seqlet_bed = seqlet_bed.sort_values(by=["chr", "start"])
    seqlet_bed.to_csv(os.path.join(output_dir, f"{file_prefix}.bed"),
        sep="\t", header=False, index=False)