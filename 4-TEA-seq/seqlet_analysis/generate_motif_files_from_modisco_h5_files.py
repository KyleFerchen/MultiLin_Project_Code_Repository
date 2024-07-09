'''
Script to extract CWMs from tfmodisco-lite h5 files saved in a given directory

Notes:
- Must load environment with ChromBPNet installed and functional
'''

usage_statement = """
    Usage:
        python generate_motif_files_from_modisco_h5_files.py 
            <path_h5_dir> <file_prefix> <output_dir>

    Positioned arguments:

        1: <path_h5_dir>: the path to the directory with all h5 files to 
            include saved. These should be tfmodisco-lite formatted otuput
            h5 files.
        2: <file_prifix>: the name with which to prefix the output motif files
        3. <output_dir>: the output directory to which to save the motif files

    """

import os
import sys
import pandas as pd
import numpy as np
import h5py


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(usage_statement)
        raise ValueError('Command requires three positional arguments.')

    # Paths
    path_h5_dir = sys.argv[1]
    file_prifix = sys.argv[2]
    output_dir = sys.argv[3]

    # Get the h5 file names in path_h5_dir
    tmp_h5_files = [item for item in os.listdir(path_h5_dir) if \
        item.endswith(".h5") and not item.startswith(".")]
    
    ### Loop through each h5 file and save the CWMs
    pos_pats = {} # Positive patterns
    neg_pats = {} # Negative patterns
    for tmp_file in tmp_h5_files:
        tmp_name = tmp_file[:-3]
        with h5py.File(os.path.join(path_h5_dir, tmp_file), "r") as tmp_h5:
            ## Save the positive patterns
            if 'pos_patterns' in list(tmp_h5):
                for tmp_pat in list(tmp_h5['pos_patterns']):
                    tmp_pat_name = f"{tmp_name}__pos_{tmp_pat}"
                    pos_pats[tmp_pat_name] = pd.DataFrame(\
                        tmp_h5['pos_patterns'][tmp_pat]\
                            ['sequence'][()]).astype(np.float32)
                
            ## Save the negative patterns
            if 'neg_patterns' in list(tmp_h5):
                for tmp_pat in list(tmp_h5['neg_patterns']):
                    tmp_pat_name = f"{tmp_name}__neg_{tmp_pat}"
                    neg_pats[tmp_pat_name] = pd.DataFrame(\
                        tmp_h5['neg_patterns'][tmp_pat]\
                            ['sequence'][()]).astype(np.float32)

    ### Write out the positive patterns found
    tmp_pos_file = os.path.join(\
        output_dir, 
        f"{file_prifix}_pos_patterns.ppm.motif")
    with open(tmp_pos_file, "w") as motif_file:
        for tmp_pat in sorted(list(pos_pats.keys())):
            x = pos_pats[tmp_pat]
            motif_file.writelines([f">{tmp_pat}\n"] + \
                ["\t".join(item) + "\n" for item in x.astype(str).values])
            
    ### Write out the negative patterns found
    tmp_neg_file = os.path.join(\
        output_dir, 
        f"{file_prifix}_neg_patterns.ppm.motif")
    with open(tmp_neg_file, "w") as motif_file:
        for tmp_pat in sorted(list(neg_pats.keys())):
            x = neg_pats[tmp_pat]
            motif_file.writelines([f">{tmp_pat}\n"] + \
                ["\t".join(item) + "\n" for item in x.astype(str).values])