
# Load R/3.5.0

setwd("/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/")

# For input
path_to_snap_files <- "/data/salomonis2/LabFiles/Kyle/Analysis/2022_01_11_mouse_tea_seq_atac/input/snap_atac_input/"

# For individual pmats
path_output_pmat_files <- "/data/salomonis2/LabFiles/Kyle/Analysis/2023_06_12_tea_seq_atac_processing/output/tea_r7_pmat_macs2_p_0_001_tss_added/"

print("Loading required packages...")
library(SnapATAC)

print("Creating paths to snap files...")
paths_data <- c(paste0(path_to_snap_files, "AS_TEAr_ML1_atac.snap"),
                paste0(path_to_snap_files, "AS_TEAr_ML2_atac.snap"),
                paste0(path_to_snap_files, "AS_TEAr_H1_atac.snap"),
                paste0(path_to_snap_files, "AS_TEAr_H2_atac.snap"))

names_data <- c("M1",
                "M2",
                "H1",
                "H2")

print("Reading in the snap objects...")
x.sp.ls = lapply(seq(paths_data), function(i){
  x.sp = createSnap(file=paths_data[i], sample=names_data[i]);
  return(x.sp)
})


# Add the pmat
print("Adding the peak matrices from the snap files...")
x.sp.ls = lapply(x.sp.ls, function(i){
  x.sp = addPmatToSnap(i)
  return(x.sp)
})


test = addPmatToSnap(x.sp.ls[[2]])

# Make the cell-by-peak matrices binary
print("Making the peak matrices binary...")
x.sp.ls = lapply(x.sp.ls, function(item){
  return(makeBinary(item, mat="pmat"))
})


# Write out the peak matrices with the barcodes and peaks
print("Writing out the sparse matrices, peaks, and barcodes...")
for(i in 1:length(x.sp.ls)){
  print(paste0("Working on capture ", names_data[i], "..."))
  # Check if output directory exists
  tmp_output_dir <- paste0(path_output_pmat_files, names_data[i], "/")
  if(!dir.exists(tmp_output_dir)){
    dir.create(tmp_output_dir)
  }
  # Assign paths for mtx, barcodes, and peaks
  tmp_path_peaks <- paste0(tmp_output_dir, "peaks.tsv")
  tmp_path_barcodes <- paste0(tmp_output_dir, "barcodes.tsv")
  tmp_path_mtx <- paste0(tmp_output_dir, "binary_pmat.mtx")
  # Write everything out...
  print("    Writing the output files...")
  writeMM(x.sp.ls[[i]]@pmat, file=tmp_path_mtx)
  write.table(x.sp.ls[[i]]@barcode, file=tmp_path_barcodes, sep="\t", col.names=F, row.names=F, quote=F)
  write.table(x.sp.ls[[i]]@peak$name, file=tmp_path_peaks, sep="\t", col.names=F, row.names=F, quote=F)
  print("    Done.")
  print("")
}