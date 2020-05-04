# $1=batch $2=email $3=file1 $4=file2
#Issues: 
    #Input: what type of files does it accept
        #Do i need to use pwd for a full filepath rather than filename
    #Output: Where does it go 
    #repeat batch control
    #Case system for passing multiple files
    #trimmomatic module location:  /ddn/home9/homlab/bin/Trimmomatic-0.38/Trimmomatic-0.38.jar
    #usr/local/apps (systemwide)

#Jarfile location
jar="/ddn/home9/homlab/bin/Trimmomatic-0.38/Trimmomatic-0.38.jar"


#Safety
if [[ $# < 2 ]]; then
    echo 'Please pass Job number and email'
    exit 1
fi

#Setup
echo ' '
echo "Trimmomatic: "
#Output
sout="$1_up.fq.gz"
pout1="$1_p1.fq.gz"
pout2="$1_p2.fq.gz"
upout1="$1_up1.fq.gz"
upout2="$1_up2.fq.gz"

#Create PBS
pbs="$1_tm.pbs"
if [ -f "$pbs" ]; then
    echo "File with this batch number exist"
    echo "Delete $pbs to continue"
    exit 1
fi
./pbs.sh $pbs $2 "tm" #create pbs
echo 'module load java' >> $pbs #module needed by pbs
read -p 'phread?(33/64) ' phred

case $# in 
    2)
    read -p 'Paired input?(y/n) ' paired  #paired or single inpt s or p 
    if [[ $paired == 'y' ]]
    then
        read -p 'Forward file: ' fr
        read -p 'Reverse file: ' rr 
        echo ' ' >> $pbs
        echo "java -jar $jar PE -phred$phred $fr $rr \\" >> $pbs
        echo "$pout1 $upout2 $pout2 $upout2 \\" >> $pbs
        echo "ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36" >> $pbs
        echo "Paired output: $pout1 | $pout2"
        echo "Unpaired output: $upout1 | $upout2" 
        echo "$pout1 $pout2" > output.txt #overwrites output.txt
 
    else
        read -p 'File: ' f
        echo ' ' >> $pbs
        echo "java -jar $jar SE -phred$phred $f $sout \\" >> $pbs
        echo "ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36" >> $pbs
        echo "output: $sout"
        echo "$sout" > output.txt #overwrites output.txt
    fi
    ;;
    3)
    echo ' ' >> $pbs
    echo "java -jar $jar SE -phred$phred $3 $sout \\" >> $pbs
	echo "ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36" >> $pbs
    echo "Output: $sout"
    echo "$sout" > output.txt #overwrites output.txt
    ;;
    4)
    echo ' ' >> $pbs
	#up=unpaired out p=paired out
	echo "java -jar $jar PE -phred$phred $3 $4 \\" >> $pbs
	echo "$pout1 $upout2 $pout2 $upout2 \\" >> $pbs
	echo "ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36" >> $pbs
    echo "Paired:   $pout1 | $pout2"
    echo "Unpaired: $upout1 | $upout2"  
    echo "$pout1 $pout2" > output.txt #overwrites output.txt
    ;;
    *)
    echo 'ERR: INVALID INPUT'
    exit 1
    ;;
esac

#control
echo -n "$pbs " >> helper.sh #passes the pbs name to build's helper function