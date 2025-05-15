#!/bin/bash
#SBATCH --nodes=1
#SBATCH -J Epi_QC_2
#SBATCH --cpus-per-task=16
#SBATCH --time=06:00:00
#SBATCH --account=csd772
#SBATCH --partition=condo
#SBATCH --qos=condo
#SBATCH -e /tscc/projects/ps-epigen/users/a2jorgensen/BpdProject/ErrorLog/Annotating/QualityFM/241005_Epithelial_QCFM_2.e-%J
#SBATCH -o /tscc/projects/ps-epigen/users/a2jorgensen/BpdProject/OutputLog/Annotating/QualityFM/241005_Epithelial_QCFM_2.o-%J
#SBATCH --mail-type ALL
#SBATCH --mail-user a2jorgensen@health.ucsd.edu

# Navigate to oasis scratch
#cd /oasis/tscc/scratch/rlancione/
# activate cond env
source /tscc/nfs/home/k1dang/miniconda3/etc/profile.d/conda.sh
conda activate seuratv5

### INPUTS 
# object path
SEU_OBJ="/tscc/projects/ps-epigen/users/a2jorgensen/BpdProject/data/Annotating/Compartments/Epithelial_Annotations_Removed_lowQC/241005_epi_removed_lowQC_clusters_sobj.RDS"
# output path
OUT_PATH="/tscc/projects/ps-epigen/users/a2jorgensen/BpdProject/data/Annotating/Compartments/Epithelial_Annotations_Removed_lowQC/QCFM_test/"
# celltype
#CELLTYPE=""
# assay to test
ASSAY="RNA"
# test to use 
TEST="wilcox"
# Project name 
NAME="Epi_BPD"
# column to correct by
HARM_COL="NONE"
# Comparison table
#COMP_PATH="/projects/ps-epigen/users/rlan/Lung_BPD/Subclustering/comparisons.txt"
COND_COL="condition"
DSET_COL="patient" 
UMAP="umap"
ORGANISM="human"
GROUPBY="SCT_snn_res.2"


#### Processing & QC script
# please note: -clust by default is seurat_cluster; specify which metacol to use
QC_Report='/tscc/nfs/home/a2jorgensen/toolbox/BpdToolbox/subclust_proc_qc.R'
Rscript $QC_Report -sobj $SEU_OBJ -n $NAME -o $OUT_PATH -hg $HARM_COL -cond $COND_COL -ds $DSET_COL -ur $UMAP -clust $GROUPBY

#### FindMarker report script 
FM_Report='/tscc/projects/ps-epigen/users/a2jorgensen/BpdProject/scripts/subclust_fm.R'
Rscript $FM_Report -sobj $SEU_OBJ -o $OUT_PATH -a $ASSAY -t $TEST -n $NAME -w 25 -org $ORGANISM -groupby $GROUPBY -ur $UMAP

#### scCustomize dotplot script 
#conda deactivate 
#conda activate seurat
#scDP="/projects/ps-epigen/users/rlan/Lung_BPD/Subclustering/scripts/clust_dotplot.R"
#Rscript $scDP -o $OUT_PATH -n $NAME 


