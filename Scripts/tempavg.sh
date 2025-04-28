#!/bin/bash -l

#SBATCH --job-name "job-name"
#SBATCH -p "CPU-node"
#SBATCH -N 1
#SBATCH -n 24
#SBATCH --time 5-00:00:00
#SBATCH --mail-type END
#SBATCH --mail-user "email"

#avg temp
for i in $(seq 0 50); do
    start_time=$((3000 * i))  			# interval start time
    end_time=$((start_time + 2000))     # interval end

    # data extraction
    grep -v "^[@#]" tg.xvg | awk -v start=$start_time -v end=$end_time \
    '$1 >= start && $1 < end {print $2}' > temp_interval_${i}.dat

    # calulcation of average
    avg_temp=$(awk '{sum += $1; count++} END {if (count > 0) print sum / count}' temp_interval_100_${i}.dat)

    # add to data file
    echo "$avg_temp" >> avg_temp.dat
done
