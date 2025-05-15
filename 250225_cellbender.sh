#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --time=48:00:00
#SBATCH --account=csd772
#SBATCH --partition=condo
#SBATCH --qos=condo 
#SBATCH -J AT2_orgo_cellb 
#SBATCH -e /tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/ErrorLog/CellBender/250225_cellbender.sh.e-%a
#SBATCH -o /tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/OutputLog/CellBender/250225_cellbender.sh.o-%a
#SBATCH --mail-type ALL                    # Optional, Send mail when the job ends
#SBATCH --mail-user a2jorgensen@health.ucsd.edu     # Optional, Send mail to this address
# generally 45 min walltime

# 24 hr walltime, ppn 16

# include these 2 lines since bash commands aren't recognized outside my base environment (subshells)
source /tscc/nfs/home/cmiciano/miniconda3/etc/profile.d/conda.sh
conda activate CellBender

# Go to working directory
## always make this cellbender_out directory before running script
#  sbatch --array=1-4 240601_cellbender.sh

#OOUT="/tscc/lustre/scratch/cmiciano/SenNet_Multiome/10_CellBender_out/"

FOUT="/tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/data/Cellbender/250225_out/"

#[[ -d $OOUT ]] || mkdir $OOUT
[[ -d $FOUT ]] || mkdir $FOUT

#cd $OOUT
cd $FOUT

# input: txt file space delimited
# format: <dataset_name> <inputfile raw_feature_bc_matrix.h5> <output_filename> <exp_num_cells> <tot_droplet> <fpr>

# Where does the exp_num_cells come from, you check the web_summary.html for a sample and input the "estimated number of cells number"
# or in the graph you can pick the number where it seems the number of cells starts to drop from the top plateau and starts sliding down
# (probably what was done in the all.rds cellbender params)

# Where does tot_droplets come from? 
# pick a number where the number of cells stops sliding and plateaus to the bottom, pick a few cells into the plateau, 
# remember the graph is logarithmic

# fpr 0.01 is the default

input_file="/tscc/projects/ps-epigen/users/a2jorgensen/sandbox/250225_humanAT2_organoids/scripts/cellbender_input.tsv"

# running CellBender remove-background
#line=`cat $input_file | sed -n ${PBS_ARRAYID}p`
line=`cat $input_file | sed -n ${SLURM_ARRAY_TASK_ID}p`
#line=`cat $input_file | sed -n 6p`
echo "LINE: "$line

name=$(echo $line | cut -f1 -d' ')
#inputFile=$(echo $line | cut -f2 -d' ') #.h5 file to be inputted into cellbender
#whole_dir=$in_dir$inputFile # absolute path to .h5 file
whole_dir=$(echo $line | cut -f2 -d' ') #in this case i specified the whole absolute path to the h5 file

outputFile=$(echo $line | cut -f3 -d' ')
expectedCells=$(echo $line | cut -f4 -d' ')
totalDroplets=$(echo $line | cut -f5 -d' ')
fprNum=$(echo $line | cut -f6 -d' ')
epoc=$(echo $line | cut -f7 -d' ')

echo "Making directory for: " $name

echo "input file: " $inputFile

echo "in dir: " $whole_dir

echo "output file: " $outputFile

echo "expected cells: " $expectedCells

echo "total droplets: " $totalDroplets

echo "fprNum: " $fprNum

echo "epochs: " $epoc

echo "PBS_ARRAYID: "${SLURM_ARRAY_TASK_ID}

echo "STARTING: "$name
# Create directory in scratch for each input
mkdir $name
cd $name

cellbender remove-background --input $whole_dir --output $outputFile --expected-cells $expectedCells --total-droplets-included $totalDroplets --fpr $fprNum --epochs $epoc   # --exclude-feature-types Peaks --> only use for multiomne

# only for sample 13
#cellbender remove-background --input $whole_dir --output $outputFile --fpr $fprNum --epochs $epoc    --exclude-feature-types Peaks

echo "compressing h5"
fi=`ls -1 *_filtered.h5`

echo $fi

ptrepack --complevel 5 $fi:/matrix ${fi%.*}"_seurat.h5":/matrix

cd ..

echo "FINISHED: "$name
## Copy sample to ps-epigen, single dir still need -R
#cp -R $name $FOUT
