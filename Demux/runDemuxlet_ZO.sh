#!/bin/sh
#SBATCH -N 1 #Number of nodes
#SBATCH -n 1 #Total number of tasks
#SBATCH -c 1                            #Cores
#SBATCH --mem=100G                       #Memory
#SBATCH -t 96:00:00 #Short for --time walltimelimit
#SBATCH -e /tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/ErrorLog/Demux/250317_organoid_ZO_demux_twolibs.e-%a
#SBATCH -o /tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/OutputLog/Demux/250317_organoid_ZO_demux_twolibs.o-%a
#SBATCH -p platinum #Partition name
#SBATCH -q hcp-csd772 #QOS name
#SBATCH -A csd772 #Allocation name
#SBATCH --mail-type ALL #Optional, Send mail when job ends
#SBATCH --mail-user a2jorgensen@health.ucsd.edu #Optional, Send mail to this address
#SBATCH --propagate=NONE

### sbatch --array=1-2 NAME OF FILE
###NOTES ARRAY BEFORE FILE NAME

source /tscc/nfs/home/k1dang/miniconda3/etc/profile.d/conda.sh
conda activate demuxlet

### USER SPECIFY ###
VCFFILE="/tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/scripts/Demux/250317_ZO_TOPMed_r209_maf01_edit_common_bedfile_catlas_1M_vars_ordered_contig.vcf"
ODIR="/tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/data/Demux/"
PROJECT="250317_AT2_organoid_ZO"

IFILE="/tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/scripts/Demux/inDemux_ZO.txt"

# batch array variables
LINE=`cat $IFILE | sed -n ${SLURM_ARRAY_TASK_ID}p`
echo "LINE: "$LINE
echo
CELLRANGER=$(echo $LINE | cut -f1 -d' ')
SAMPLE=$(echo $LINE | cut -f2 -d' ')
### DONE ###

echo "### USER VARIABLES ###"
echo "VCFFILE: "$VCFFILE
echo "ODIR: "$ODIR
echo "PROJECT: "$PROJECT
echo "CELLRANGER: "$CELLRANGER
echo "SAMPLE: "$SAMPLE
echo "###  DONE W/ VARS  ###"
mkdir $ODIR
cd $ODIR

# run demuxlet
echo
echo "Start Demuxlet run"
mkdir ${ODIR}${PROJECT}/
mkdir ${ODIR}${PROJECT}/popscle_out/
mkdir ${ODIR}${PROJECT}/temp/

bash /tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/scripts/Demux/Popscle_demuxletAllinOneScript_RNAONLY_final.sh \
    -t ${ODIR}${PROJECT}/temp \
    -i ${CELLRANGER} -s ${SAMPLE} -o ${ODIR}${PROJECT}/popscle_out \
    -v ${VCFFILE}
echo "DONE! :)"
