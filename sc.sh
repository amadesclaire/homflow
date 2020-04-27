#Safety
if [[ $# < 2 ]]; then
    echo 'Please pass Job number and email'
    exit 1
fi

echo ' '
echo 'Sickle: '
#Output 
o1="$1_sc1.fq.gz"
o2="$1_sc2.fq.gz"

#Create Pbs
pbs="$1_sc.pbs"
if [ -f "$pbs" ]; then
    echo "File with this job number exist"
    echo "Delete $pbs to continue"
    exit 1
fi
./pbs.sh $pbs $2 "sc"
echo "module load python" >> $pbs
echo "source activate bioinf" >> $pbs #sickle is in bioinf
read -p 'quality type(12/33/64)' phred

function single() { # $pbs $phred $f1 $o1
	echo "sickle se -g -f $3 -t illumina -o $4 -q $2" >> $pbs
    echo "$4" > output.txt
}

function paired() { # $pbs $phred $f1 $f2 $o1 $o2
	echo "sickle pe -g -f $3 -r $4 -t sanger \\" >> $pbs
    echo "-o $5 -p $6 \\" >> $pbs
    echo "-s SC_singles.fq.gz -q $2" >> $pbs
    echo "$5 $6" > output.txt
}

function prompt() { # $pbs $phred $o1 $o2
    read -p "Paired reads?(y/n) " paired
    if [[ $paired == 'y' ]]
    then 
        read -p "forward read: " fr
        read -p "reverse read: " rr
        paired $1 $fr $rr $2 $3
        echo "Output:   $o1 | $o2"
    else
        read -p "File: " f 
        single $1 $2 $f $3
        echo "Output: $3"
    fi
}

case $# in
    2) 
    prompt $pbs $phred $o1 $o2
    ;;
	3) 
    single $pbs $phred $3 $o1
	;;
	4)
    paired $pbs $phred $3 $4 $o1 $o2
	;;
    *)
    echo 'ERR: INVALID INPUT'
    exit 1
    ;;
esac

#control
echo -n "$pbs " >> helper.sh #passes the pbs name to build's helper function