# ADT Sub-clustering on non-log2 ADTs using ICGS2
python AltAnalyze.py \
    --runICGS yes \
    --species Mm \
    --platform RNASeq \
    --excludeCellCycle no \
    --removeOutliers no \
    --restrictBy None \
    --expdir exp.TotalVI.txt \
    --markerPearsonCutoff 0.10 \
    --k 25 \
    --column_method ward \
    --row_method ward \
    --FoldDiff 1 \
    --ExpressionCutoff 0 \
    --rho 0.15

# ADT Sub-clustering for 13 initial ADT clusters on non-log2 ADTs using ICGS2
python AltAnalyze.py \
    --runICGS yes \
    --species Mm \
    --platform RNASeq \
    --excludeCellCycle no \
    --removeOutliers no \
    --restrictBy None \
    --markerPearsonCutoff 0.10 \
    --k 25 \
    --column_method ward \
    --row_method ward \
    --FoldDiff 1 \
    --ExpressionCutoff 0 \
    --rho 0.15 \
    --expdir $ClusterCPTTFile

# RNA Initial clustering all cells using ICGS2
python AltAnalyze.py \
    --runICGS yes \
    --platform "RNASeq" \
    --species Mm \
    --restrictBy protein_coding \
    --expdir /MergedFiles-SoupX.txt \
    --excludeCellCycle no \
    --removeOutliers no \
    --expname CITE

# RNA Sub-clustering for initial HSC, MultiLin and CD127 ICGS2 aggregate populations
python AltAnalyze.py \
    --runICGS yes \
    --platform "RNASeq" \
    --species Mm \
    --restrictBy protein_coding \
    --expdir /MultiLin/MergedFiles-SoupX-filtered.txt \
    --excludeCellCycle no \
    --removeOutliers no \
    --expname CITE
