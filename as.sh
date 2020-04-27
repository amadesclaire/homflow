#issues
    #AntiSmash https://docs.antismash.secondarymetabolites.org/install/
    #figure out output dir
#Safety
if [[ $# < 2 ]]; then
    echo 'Please pass Job number and email'
    exit 1
fi

#Setup
echo ' '
echo 'AntiSmash: '
#I/O
input="$3"
outputDir=""     ####fixme
options=""

#Create PBS
pbs="$1_as.pbs"
if [ -f "$pbs" ]; then
    echo "File with this batch number exist"
    echo "Delete $pbs to continue"
    exit 1
fi
./pbs.sh $pbs $2 "as"
echo "module load python" >> $pbs
echo "source activate bioinf" >> $pbs

#Menu Options
case $# in 
    2)
        read -p "Input? " input
        read -p '1. Full run 2. Minimal run 3. Custom run 4. Fast run' runtype
        case runtype in
            1)
            echo "antismash --cb-general --cb-knownclusters --cb-subclusters --asf --pfam2go --smcog-trees $input" >> $pbs
            ;;
            2)
            echo "antismash --minimal $input" >> $pbs
            ;;
            3)
            read -p "Options: " options
            echo "antismash $options $input" >> $pbs
            ;;
            4)
            echo "antismash $input" >> $pbs
            ;;
            *)
            echo "ERROR"
            exit 1
            ;;
        esac
    ;;
    3)
        read -p '1. Full run 2. Minimal run 3. Custom run 4. Fast run' runtype
        case runtype in
            1)
            echo "antismash --cb-general --cb-knownclusters --cb-subclusters --asf --pfam2go --smcog-trees $input" >> $pbs
            ;;
            2)
            echo "antismash --minimal $input" >> $pbs
            ;;
            3)
            read -p "Options: " options
            echo "antismash $options $input" >> $pbs
            ;;
            4)
            echo "antismash $input" >> $pbs
            ;;
            *)
            echo "ERROR"
            exit 1
            ;;
        esac
    ;;
    4)
        read -p '1. Full run 2. Minimal run 3. Custom run 4. Fast run' runtype
        case runtype in
            1)
            echo "antismash --cb-general --cb-knownclusters --cb-subclusters --asf --pfam2go --smcog-trees $input" >> $pbs
            ;;
            2)
            echo "antismash --minimal $input" >> $pbs
            ;;
            3)
            read -p "Options: " options
            echo "antismash $options $input" >> $pbs
            ;;
            4)
            echo "antismash $input" >> $pbs
            ;;
            *)
            echo "ERROR"
            exit 1
            ;;
        esac
        ;;
    *)
        echo "ERROR: Invalid Input"
    ;;
esac

#output
echo "$outdir" > output.txt
#control
echo -n "$pbs " >> helper.sh #passes the pbs name to build's helper function

