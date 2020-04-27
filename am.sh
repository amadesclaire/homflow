#DO NOT USE ./pbs.sh
input="$3"
output=""

#Safety
if [[ $# < 2 ]]; then 
    echo 'Please pass Job number and email'
    exit 1
fi

#Generate coverage table if not SPAdes
read -p "Have you run SPAdes?(y/n)" spades
if [[ $spades == 'n' ]]; then
	echo "Generate coverage table" 
    pbsct="$1_am0.pbs"
	read -p "CPUs? " cpu
	read -p "Gb of Memory? " mem
	read -p "Cut off length?(3000) " cutoff
	touch $pbsct
	echo '#!/bin/bash' >> $pbsct
	echo '#PBS -N am1' >> $pbsct			
	echo '#PBS -l ncpus='$cpu >> $pbsct
	echo '#PBS -l mem='$mem'gb' >> $pbsct
	echo '#PBS -m abe' >> $pbsct
	echo '#PBS -M '$2 >> $pbsct
	echo 'umask 007' >> $pbsct
	echo '$PBS_O_WORKDIR' >> $pbsct
	echo ' ' >> $pbsct
	echo 'module load python' >> $pbsct
	echo 'source activate autometa' >> $pbsct
	echo 'export PATH=/usr/local/apps/autometa/pipeline:$PATH' >> $pbsct  #what does this mean
	echo 'module load prodigal' >> $pbsct
	echo ' ' >> $pbsct
    read -p "Contigs.fasta filepath?: " contigs #get contig
	echo "calculate_read_coverage.py --assembly $contigs --processors $cpu \\" >> $pbsct
    read -p "Paired end reads?(y/n)" paired
    if [[ $paired == 'y' ]]
    then 
        read -p "Forward file: " ff 
        read -p "Reverse file: " rf
        echo "--forward_reads $ff --reverse_reads $rf" >> $pbsc
    else
        read -p "File path: " f
        echo "-S $f \\" >> $pbsc
    fi
    read -p "Where do you want the coverage table output?" out
    echo "-o $out" >> $pbsc
    
    coverageTable="$out/coverage.tab"
    #control
    echo -n "$pbsct " >> helper.sh #passes the pbs name to build's helper function
fi

#Control
read -p 'run all processes? (y/n)' all
if [[ all = 'n' ]] 
then
	#Split Into Kingdom Bins******************************************************************************
	read -p 'Split data into kingdom bins? (y/n)' split
	if [[ $split == 'y' ]]; then
		#Generate PBS 
        pbs1="$1_am1.pbs"
		read -p "CPUs? " cpu
		read -p "Gb of Memory? " mem
		read -p "Cut off length?(3000) " cutoff

		touch $pbs1
		echo '#!/bin/bash' >> $pbs1
		echo '#PBS -N am1' >> $pbs1			
		echo '#PBS -l ncpus='$cpu >> $pbs1
		echo '#PBS -l mem='$mem'gb' >> $pbs1
		echo '#PBS -m abe' >> $pbs1
		echo '#PBS -M '$2 >> $pbs1
		echo 'umask 007' >> $pbs1
		echo '$PBS_O_WORKDIR' >> $pbs1
		echo ' ' >> $pbs1
		echo 'module load python' >> $pbs1
		echo 'source activate autometa' >> $pbs1
		echo 'export PATH=/usr/local/apps/autometa/pipeline:$PATH' >> $pbs1  #what does this mean
		echo 'module load prodigal' >> $pbs1
		echo ' ' >> $pbs1
        #Ask custom DB
        read -p "Custom database directory? " db
        if [ -z "$db" ]
        then 
            db="-db $db"
        else
            db=""
        fi
		echo "make_taxonomy_table.py --a $input/scaffolds.fasta$db--processors $cpu --length_cutoff $cutoff" >> $pbs1

		#output ???
		#control
	    echo -n "$pbs1 " >> helper.sh #passes the pbs name to build's helper function


	fi

	#Bin Contigs with BH-tSNE and DBSCAN *****************************************************************
	pbs2="$1_am2.pbs"

	#Prompt
	read -p "CPUs? " cpu
	read -p "Gb of Memory? " mem
	#Create PBS 
	touch $pbs2
	echo '#!/bin/bash' >> $pbs2
	echo '#PBS -N am2' >> $pbs2			#REPLACE THIS WITH $3 AND PASS NAMES
	echo '#PBS -l ncpus='$cpu >> $pbs2
	echo '#PBS -l mem='$mem'gb' >> $pbs2
	echo '#PBS -m abe' >> $pbs2
	echo '#PBS -M '$2 >> $pbs2
	echo 'umask 007' >> $pbs2
	echo '$PBS_O_WORKDIR' >> $pbs2
	echo ' ' >> $pbs2
	echo 'module load python' >> $pbs2
	echo 'source activate autometa' >> $pbs2
	echo 'export PATH=/usr/local/apps/autometa/pipeline:$PATH'  #what does this mean
	echo 'module load prodigal' >> $pbs2
	tab="" #Taxonomy table filepath needs to go here
	fasta= "" #Below need to find filepath for bacteria.fasta
	echo "run_autometa.py --assembly $fasta --processors $cpu --length_cutoff $cutoff --taxonomy_table $tab " >> $pbs2

	#output ???

	#Control
  	echo -n "$pbs2 " >> helper.sh #passes the pbs name to build's helper function


	#Recruit unclustered contigs to bins *****************************************************************
	read -p 'Recruit unclustered contigs to bins through supervised machine learning?(y/n) ' ml
	if [[ $ml == 'y' ]]; then
		pbs3="$1_am3.pbs"
		
		#prompt
		read -p "CPUs? " cpu
		read -p "Gb of Memory? " mem
		#create pbs
		touch $pbs3
		echo '#!/bin/bash' >> $pbs3
		echo '#PBS -N am2' >> $pbs3			#REPLACE THIS WITH $3 AND PASS NAMES
		echo '#PBS -l ncpus='$cpu >> $pbs3
		echo '#PBS -l mem='$mem'gb' >> $pbs3
		echo '#PBS -m abe' >> $pbs3
		echo '#PBS -M '$2 >> $pbs3
		echo 'umask 007' >> $pbs3
		echo '$PBS_O_WORKDIR' >> $pbs3
		echo ' ' >> $pbs3
		echo 'module load python' >> $pbs3
		echo 'source activate autometa' >> $pbs3
		echo 'export PATH=/usr/local/apps/autometa/pipeline:$PATH' >> pbs3  #what does this mean
		echo ' '
		echo 'module load prodigal' >> $pbs3

		table= /???/recursive_dbscan_output.tab
		kmer_matrix=/???/k-mer_matrix
		echo "ML_recruitment.py --contig_tab $table --k_mer_matrix $kmer_matrix" >> $pbs3

		#output ????
		echo -n "$pbs3 " >> helper.sh #passes the pbs name to build's helper function

	fi
else
	echo 'Autometa: '
	pbsall="$1_am.pbs"
	#prompt
	read -p "CPUs? " cpu
	read -p "Gb of Memory? " mem
	read -p "Cut off length?(3000) " cutoff
	#create pbs (This can be changed to a single line with printf)
	touch $pbsall
	echo '#!/bin/bash' >> $pbsall
	echo '#PBS -N amAll' >> $pbsall			#REPLACE THIS WITH $3 AND PASS NAMES
	echo '#PBS -l ncpus='$cpu >> $pbsall
	echo '#PBS -l mem='$mem'gb' >> $pbsall
	echo '#PBS -m abe' >> $pbsall
	echo '#PBS -M '$2 >> $pbsall
	echo 'umask 007' >> $pbsall
	echo '$PBS_O_WORKDIR' >> $pbsall
	echo ' ' >> $pbsall
	echo 'module load python' >> $pbsall
	echo 'source activate autometa' >> $pbsall
	echo 'export PATH=/usr/local/apps/autometa/pipeline:$PATH' >> $pbsall #what does this mean
	echo ' ' >> $pbsall
	echo 'module load prodigal' >> $pbsall
	if [[ spades == 'y' ]]
	then
		read -p "Scaffolds location:" scaffolds
	else
		scaffolds='autometa/test_data/scaffolds.fasta' #should be ~/autometa/test_data/scaffolds.fasta
	fi
	echo "run_autometa.py --assembly $scaffolds --processors $cpu --length_cutoff $cutoff --maketaxtable --ML_recruitment" >> $pbsall
	
	#output
	#control
    echo -n "$pbsall " >> helper.sh #passes the pbs name to build's helper function

	
fi