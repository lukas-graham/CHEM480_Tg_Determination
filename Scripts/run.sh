#!/bin/bash -l

#SBATCH --job-name "job-name"
#SBATCH -p "CPU_node"
#SBATCH -N 1
#SBATCH -n 24
#SBATCH --time 5-00:00:00
#SBATCH --mail-type END
#SBATCH --mail-user "email"

module load apps/gromacs_cuda/2022.0

gmx grompp -f tg.mdp -c "input".gro -p "input".top -o tg.tpr

gmx mdrun -deffnm tg -nt 24 -tableb "table".xvg 