#!/bin/bash -l

#SBATCH --job-name "job-name"
#SBATCH -p "CPU-node"
#SBATCH -N 1
#SBATCH -n 24
#SBATCH --time 5-00:00:00
#SBATCH --mail-type END
#SBATCH --mail-user "email"

module load apps/gromacs_cuda/2022.0

structure_file="tg.tpr"
index_file="repeat_500.ndx"
num_repeats=500
atoms_per_unit=105

if [ ! -f "$index_file" ]; then
    echo "generating index file..."

    # temp index file to hold group selection
    echo "0" > tmp_ndx.txt  # whole system

    # 500 repeat units created
    for i in $(seq 0 $((num_repeats - 1))); do
	        start=$((i * atoms_per_unit + 1))
        end=$((start + atoms_per_unit - 1))
        echo "a $start-$end" >> tmp_ndx.txt 
    done

    echo "q" >> tmp_ndx.txt

    # make index and remove temp file
    gmx make_ndx -f $structure_file -o $index_file < tmp_ndx.txt
    rm tmp_ndx.txt
fi

# loop over temp intervals
for i in $(seq 0 55); do
    A=$((3000 * i)) # interval start time
    B=$((A + 2000)) # interval end time

    sum_msd=0

	# average over the 500 repeat units in index file
    for j in $(seq 7 506); do
        echo -e "$j" | gmx msd -f tg.xtc -s tg.tpr -n $index_file -b $A -e $B -o msd_repeat_${i}_unit_${j}.xvg
        grep -v "^[@#]" msd_repeat_${i}_unit_${j}.xvg > msd_repeat_${i}_unit_${j}.dat
        last_msd=$(awk 'END {print $2}' msd_repeat_${i}_unit_${j}.dat)
        sum_msd=$(echo "$sum_msd + $last_msd" | bc -l)
    done
	
	avg_msd=$(echo "$sum_msd / $num_repeats" | bc -l)
    echo "$avg_msd" >> msd_repeat_500.dat
done