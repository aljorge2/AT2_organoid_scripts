#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00
#SBATCH -J create_sobj
#SBATCH --mem 200G
#SBATCH --account=csd772
#SBATCH --partition=condo
#SBATCH --qos=condo
#SBATCH -e /tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/ErrorLog/250322_create_sobj_sct_processing.e-%J
#SBATCH -o /tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/OutputLog/250322_create_sobj_sct_processing.o-%J
#SBATCH --mail-type ALL                      # Optional, Send mail when the job ends
#SBATCH --mail-user a2jorgensen@health.ucsd.edu     # Optional, Send mail to this address
# generally 45 min walltime

# activate cond env
source /tscc/nfs/home/cmiciano/miniconda3/etc/profile.d/conda.sh

conda activate seuratv5

# took a around 3 hours 16ppn
# 16ppn in parallel, using lognormalize, set ram to 7GB s


RDS_PATH="/tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/data/rds_objs/250319_three_libs_w_demux_meta.RDS"
# RDS_PATH='/tscc/projects/ps-epigen/users/a2jorgensen/sandbox/241212_FNIH_liver/241213_batchcorr_metadata_RNA_only_HSCs.RDS'

CORR="batch"

OUT_PATH='/tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/data/SCT/250322_three_libs_run_noharm/'
# OUT_PATH='/tscc/projects/ps-epigen/users/a2jorgensen/sandbox/241212_FNIH_liver/241213_reclustered_HSCs/'

PROJ='250322_3_libs_w_demux_meta_sct'
#PROJ="241213_RNA_only_reclustered_HSCs"

# parallel or single core
RUN_MODE="parallel"

# num of processors (only used if run mode is parallel)
NUM_WORKERS="16"

# metadata column to correct by when running batch correction (orig.ident, library_rna_atac_id, donor)
BATCH_COL_MD="orig.ident" #orig.ident is library_rna_atac_id

# name of chrom assay to process
#CHROM_ASSAY="ATAC_comb"

[[ -d $OUT_PATH ]] || mkdir $OUT_PATH

Script='/tscc/projects/ps-epigen/users/a2jorgensen/Lung_ALD/scripts/241012_clust_multiome.R'
Rscript $Script -sobj $RDS_PATH -bc $CORR -out $OUT_PATH -rds $PROJ -rm $RUN_MODE -w $NUM_WORKERS -bcol $BATCH_COL_MD #-ca $CHROM_ASSAY
