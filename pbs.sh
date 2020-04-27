#$pbsname $email

#writes pbs
read -p "CPUs? " cpu
read -p "Gb of Memory? " mem
touch $1 #create file
echo '#!/bin/bash' >> $1
echo "#PBS -N $3" >> $1			#REPLACE THIS WITH $3 AND PASS NAMES
echo '#PBS -l ncpus='$cpu >> $1
echo '#PBS -l mem='$mem'gb' >> $1
echo '#PBS -m abe' >> $1
echo '#PBS -M '$2 >> $1
echo 'umask 007' >> $1
echo '$PBS_O_WORKDIR' >> $1
echo ' ' >> $1
