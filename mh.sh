#Safety
if [[ $# < 2 ]]; then
    echo 'No batch or email passed'
    exit 1
fi

#Setup
echo ' '
echo 'MegaHit: '
out=$(echo $PWD)

#Create PBS
pbs="$1_mh.pbs"
if [ -f "$pbs" ]; then
    echo "File with this batch number exist"
    echo "Delete $pbs to continue"
    exit 1
fi
./pbs.sh $pbs $2 "mh" #create pbs
echo "module load python" >> $pbs
echo "module load MEGAHIT" >> $pbs
read -p "Options:(press enter if none) " options

#Functions
function single() { # $pbs $outDir $options $f1 
    echo "megahit $3 -r $4 -o $2" >> $1
    echo "$2/final.contigs.fa" > output.txt

}

function paired() { #$pbs $out $options $f1 $f2
    echo "megahit $3 -1 $4 -2 $5 -o $2" >> $1 
    echo "$2/final.contigs.fa" > output.txt
}

function prompt() { #$pbs $out $options
    read -p "Paired end reads?(y/n) " paired
    if [[ $paired == 'y' ]]
    then
        read -p "Forward read: " fr
        read -p "Reverse read: " rr 
        paired $1 $2 $3 $fr $rr
    else
        read -p "File: " f
        single $1 $2 $3 $f
    fi
}


#Chooses function based on arguments passed
case $# in
    2)
    prompt $pbs $out $options
    ;;
	3) 
    single $pbs $out $options $3
	;;
	4)
    paired $pbs $out $options  $3 $4
	;;
    *)
    echo "ERR: INVALID INPUT"
    exit 1
    ;;
esac

echo 'output: final.contigs.fa'

#control
echo -n "$pbs " >> helper.sh #passes the pbs name to build's helper function
