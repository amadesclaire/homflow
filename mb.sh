if [[ $# < 2 ]]; then
    echo 'Please pass Job number and email'
    exit 1
fi

echo ' '
echo 'metaBGC: '
#Output 
outdir=""

#Create Pbs
pbs="$1_mb.pbs"
if [ -f "$pbs" ]; then
    echo "File with this job number exist"
    echo "Delete $pbs to continue"
    exit 1
fi
./pbs.sh $pbs $2 "mb"
echo "module load python" >> $pbs
echo "source activate bioinf" >> $pbs #sickle is in bioinf