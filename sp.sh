#Safety
if [[ $# < 2 ]]; then #Makes sure minimum input
    echo 'Please pass Job number and email'
    exit 1
fi

echo ' '
echo "SPAdes: "
#output                
outdir="homflow/$1/spades"

#Create PBS
pbs="$1_sp.pbs"
if [ -f "$pbs" ]; then
    echo "File with this batch number exist"
    echo "Delete $pbs to continue"
    exit 1
fi
./pbs.sh $pbs $2 "sp"
echo "module load python" >> $pbs
echo "source activate bioinf" >> $pbs
read -p 'MetaSPAdes?(y/n) ' meta
if [[ $meta == 'y' ]]
then 
	meta="--meta "
else 
    meta=""
fi
read -p "Options:(hit enter if none) " options
if [ -z "$options" ]
then 
    options=""
else
    options="$options "
fi

#Control
case $# in
	2) 
        read -p 'Paired end reads?(y/n) ' paired  
        if [[ $paired == 'y' ]]
        then
            read -p "Forward file: " ff
            read -p "Reverse file: " rf
            echo ' ' >> $pbs
            echo "spades.py $meta$options--pe1-1 $ff --pe1-2 $rf -o $outdir" >> $pbs 	
        else 
            read -p "File: " file
            echo ' ' >> $pbs
            echo "spades.py -1 $meta$options$file -o $outdir"  >> $pbs
        fi
        ;;
	3) 
        echo ' ' >> $pbs
        echo "spades.py -1 $meta$options$3 -o $outdir"  >> $pbs
	    ;;
	4)
        echo ' ' >> $pbs
        echo "spades.py $meta$options--pe1-1 $3 --pe1-2 $4 -o $outdir" >> $pbs 	
	;;
    *)
        echo 'ERR: INVALID INPUT'
        exit 1
        ;;
esac

echo "$outdir" > output.txt
#control
echo -n "$pbs " >> helper.sh #passes the pbs name to build's helper function


