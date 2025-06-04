#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --time=6:00:00
#SBATCH -J QCFM
#SBATCH --mem 50G
#SBATCH --account=csd772
#SBATCH --partition=condo
#SBATCH --qos=condo
#SBATCH -e /tscc/projects/ps-epigen/users/a2jorgensen/AT2_organoid/ErrorLog/250528_QC_organoid.e-%J
#SBATCH -o /tscc/projects/ps-epigen/users/a2jorgensen/AT2_organoid/OutputLog/250528_QC_organoid.o-%J
#SBATCH --mail-type ALL                      # Optional, Send mail when the job ends
#SBATCH --mail-user a2jorgensen@health.ucsd.edu     # Optional, Send mail to this address
# generally 45 min walltime

# Navigate to oasis scratch
#cd /oasis/tscc/scratch/rlancione/
# activate cond env
source /tscc/nfs/home/k1dang/miniconda3/etc/profile.d/conda.sh
conda activate seuratv5

### INPUTS 
# object path
SEU_OBJ="/tscc/projects/ps-epigen/users/a2jorgensen/AT2_organoid/data/SCT/250507_corr_demux_add/250509_3lib_sng_w_all_meta.RDS"
# output path
OUT_PATH="/tscc/projects/ps-epigen/users/a2jorgensen/AT2_organoid/data/Quality/250528_QC_reports/"
# celltype
#CELLTYPE=""
# assay to test
ASSAY="RNA"
# test to use 
TEST="wilcox"
# Project name 
NAME="AT2_organoid_3libs"
# column to correct by
HARM_COL="orig.ident"
# Comparison table
#COMP_PATH="/projects/ps-epigen/users/rlan/Lung_BPD/Subclustering/comparisons.txt"
COND_COL="condition"
DSET_COL="SNG.BEST.GUESS" 
UMAP="umap.harmony.rna"
ORGANISM="human"
GROUPBY="seurat_clusters"


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


