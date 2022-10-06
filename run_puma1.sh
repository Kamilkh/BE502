#!/bin/bash

if test $# -lt 1
then
# echo "usage: cmmand [arg_list]"; exit
 echo "usage: year [yyyy[-mm-dd]]"
 exit
fi
#cmd=$1; shift; args=$*
year=$1

sfile=BE502_$(date +%N).slurm
tasks=5

echo "#!/bin/bash">$sfile
echo "#SBATCH -A windfall --partition=windfall">>$sfile
echo "#SBATCH -J BE502_$(whoami)_job" >>$sfile
echo "#SBATCH --nodes=$tasks --ntasks-per-node=2 --mem=5gb">>$sfile  #-N
echo "#SBATCH -t 4:00:00">>$sfile
echo "cd \$SLURM_SUBMIT_DIR">>$sfile
echo "echo $SLURM_SUBMIT_DIR\$SLURM_NNODES">>$sfile
echo "module load R python/3.6">>$sfile
echo "srun -n $tasks --ntasks-per-node=1 --cpus-per-task=1 grep -i '$year.*Good' tucson_rain.txt | awk -F'\t' '{sum+=\$9}; END {print sum}'" >>$sfile
sbatch $sfile