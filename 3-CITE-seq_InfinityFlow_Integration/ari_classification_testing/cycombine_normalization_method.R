setwd("/media/kyle_storage/kyle_ferchen/grimes_lab_main/analysis/2023_06_04_cycombine_testing_with_their_data/")

library(cyCombine)

path_cite <- paste0("/media/kyle_storage/kyle_ferchen/grimes_lab_main/analysis/2022_12_07_new_multilin_panel/",
  "output/cite_inflow_integration_input/without_adt_umi_filtering/pre_mapped_cite_ari_adt_alone_all_cells.fea")

path_inflow <- paste0("/media/kyle_storage/kyle_ferchen/grimes_lab_main/analysis/2022_12_07_new_multilin_panel/",
  "output/cite_inflow_integration_input/gated_inflow_inputs/inflow_gated_1k_each_ari_groups_adt_alone.fea")

path_adt_links <- paste0("/media/kyle_storage/kyle_ferchen/grimes_lab_main/analysis/2022_12_07_new_multilin_panel/",
  "output/cite_inflow_integration_input/links_adt.csv")

cite <- arrow::read_feather(path_cite)
inflow <- arrow::read_feather(path_inflow)

adt_links <- read.csv(path_adt_links)
rownames(adt_links) <- paste0("ADT_Link-", adt_links$Link, ":", adt_links$OPTI_ADT, ":", adt_links$Channel)

inflow <- inflow[,rownames(adt_links)]
cite <- cite[,rownames(adt_links)]


inflow$batch <- "InfinityFlow"
cite$batch <- "CITE"

uncorrected <- dplyr::bind_rows(cite, inflow)

seed <- 7
set.seed(seed)

corrected_total <- uncorrected %>%
  batch_correct(seed = seed,
                xdim = 8,
                ydim = 8,
                norm_method = 'rank',
                ties.method = 'average')

arrow::write_feather(corrected_total, "/media/kyle_storage/kyle_ferchen/grimes_lab_main/analysis/2022_12_07_new_multilin_panel/output/cite_inflow_integration_input/cycombine_cite_inflow_ari_input/cite_inflow_cycombine_ari_adt_alone_input.fea")


