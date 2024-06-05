setwd("/media/kyle_storage/kyle_ferchen/grimes_lab_main/analysis/2022_01_11_mouse_tea_seq_atac/")

library(leiden)

tmp_graph <- readRDS("output/mouse_tea_seq_nov_combined_GRAPH_OUTPUT_FOR_LEIDEN.RDS")

tmp_leiden_res_1 <- leiden(tmp_graph, resolution=1)
tmp_leiden_res_2 <- leiden(tmp_graph, resolution=2)
tmp_leiden_res_4 <- leiden(tmp_graph, resolution=4)
tmp_leiden_res_point5 <- leiden(tmp_graph, resolution=0.5)

cell_anno <- read.table("output/mouse_tea_seq_nov_combined_CELL_ANNOTATION.txt", header=T)
cell_anno$leiden_res_1 <- tmp_leiden_res_1
cell_anno$leiden_res_2 <- tmp_leiden_res_2
cell_anno$leiden_res_4 <- tmp_leiden_res_4
cell_anno$leiden_res_pt5 <- tmp_leiden_res_point5

write.table(cell_anno, file="output/mouse_tea_seq_nov_combined_CELL_ANNOTATION_ADD_CLUSTERING.txt",
            row.names=F, col.names=T, quote=F)

