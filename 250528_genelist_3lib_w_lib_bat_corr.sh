#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --account=csd772
#SBATCH --partition=condo
#SBATCH --qos=condo
#SBATCH -J epi_genes
#SBATCH -e /tscc/projects/ps-epigen/users/a2jorgensen/AT2_organoid/ErrorLog/250528_genelist_organoid.e-%J
#SBATCH -o /tscc/projects/ps-epigen/users/a2jorgensen/AT2_organoid/OutputLog/250528_genelist_organoid.o-%J
#SBATCH --mail-type ALL                      # Optional, Send mail when the job ends
#SBATCH --mail-user a2jorgensen@health.ucsd.edu      # Optional, Send mail to this address

# Navigate to oasis scratch
#cd /oasis/tscc/scratch/rlancione/

# activate cond env
source /tscc/nfs/home/cmiciano/miniconda3/etc/profile.d/conda.sh

conda activate seuratv5

### INPUTS 
# object path
# using already clustered object
GENE_LIST_PATH="/tscc/projects/ps-epigen/users/a2jorgensen/BpdProject/scripts/subclust_gene_list/"
#GENE_LIST_PATH="/tscc/projects/ps-epigen/users/cmiciano/Liver/NASH_NAFLD_pooling/scripts/02_40_nocb_df/gene_lists/pando_gl"

# pattern to subset gene lists
PATTERN="epi"

SEU_OBJ="/tscc/projects/ps-epigen/users/a2jorgensen/AT2_organoid/data/SCT/250507_corr_demux_add/250509_3lib_sng_w_all_meta.RDS"

# ident to group by dotplots by #seurat_clusters, wsnn_res.0.25, RNA_snn_res.0.5 
IDENT="seurat_clusters"

# output path
OUT_PATH="/tscc/projects/ps-epigen/users/a2jorgensen/AT2_organoid/data/Quality/250528_genelist"

# condition to group by for ucell
CONDITION="orig.ident"

COND_ORD="BPD_healed_control,BPD_healed,BPD_Chronic_control,BPD_Chronic,Active_evolving_control,Active_evolving"

# tissue to convert gene liest names too
TISSUE_ORG="hsapiens"

UMAP="umap"

[[ -d $OUT_PATH ]] || mkdir $OUT_PATH

#### FindMarker report script 
#### scCustomize dotplot script 
#scDP='/projects/ps-epigen/users/cmiciano/Liver/RNA/scripts/subclustering/clust_dotplot.R'
#Rscript $scDP -sobj $SEU_OBJ -o $OUT_PATH -n $NAME -i $IDENT 
KM_Report='/tscc/projects/ps-epigen/users/a2jorgensen/BpdProject/scripts/run_knowmark.R'
Rscript $KM_Report -glp $GENE_LIST_PATH -pat $PATTERN -sobj $SEU_OBJ -i $IDENT -c $CONDITION -co $COND_ORD -o $OUT_PATH -org $TISSUE_ORG -u $UMAP
#Rscript $KM_Report -glp $GENE_LIST_PATH -sobj $SEU_OBJ -i $IDENT -c $CONDITION -co $COND_ORD -o $OUT_PATH -org $TISSUE_ORG -u $UMAP

