#Issues
    #could ad a config file to stop asking email
    #could auto generate batch names
    #switch all batch to job

#Help ****************************************************************
function h() {
    echo "Homflow helps you build bioinformatics pipelines"
    echo "You can build a single pbs pbs script by typing ./ + any of the two letter codes with a batch number and email"
    echo "To build an entire pipeline type go and follow the instructions"
}

#Go *****************************************************************
function go() {
    echo ' '
	#Get info 
    read -p "Job name: " job   	#username=$( echo "$email" | cut -d "@" -f1) #gets olemiss uid from email
	if [[ -f "$job.pbs" ]]; then 
        echo 'Error: Existing job name'
        exit 1
    fi
    read -p "Email: " email
    
    #HELPERS
    touch $job.sh #this script will initialize the pipeline
    #overwrites previous helper
    echo -n "./build.sh $job " > helper.sh #helper allows us to pass pipeline components to the build script
    
    #Getting Pipeline info
    echo "1a) Trimmomatic: tm    1b) Sickle:    sc    2a) MegaHit:   mh    2b) Spades:    sp  "
    echo "3)  AutoMeta:    am    4a) AntiSmash: as    4b) MetaBGC:   mb"	 
    read -p "First step? " step
    ./$step.sh $job $email 

    loop='y'
    while [ $loop == 'y' ]
    do
        read -p "Add step to pipeline?(y/n) " loop
        if [[ $loop == 'y' ]]; then
            echo "1a) Trimmomatic: tm    1b) Sickle:    sc    2a) MegaHit:   mh    2b) Spades:      sp  "
            echo "3)  AutoMeta:    am    4a) AntiSmash: as    4b) MetaBGC:   mb        Finished:    f"	 
            read -p "Next Step? " step
            read -r input < output.txt
            ./$step.sh $job $email $input
        fi
    done   

    #After options run
    ./helper.sh #passes created PBSs to build function
    chmod +x $job.sh 

    #Prompt Begin pipeline
	read -p "Run now (y) or not (n) " start 
    if [[ $start == 'y' ]]
    then 
        echo "./$job.sh"
        echo 'Pipeline running!'
    else
        echo "To run later enter ./$job.sh"
    fi
}

#Menu *********************************************************************
function menu(){
	read CMD
	case $CMD in 
	    go)
	        go
	        ;;
	    help)
	        h
	        ;;
	    s)
	        ./setup.sh
	        ;;
	    *) 
	        echo "Function not found"
	        ;;
	esac
}

#Interface *****************************************************************
if [[ $# -eq 0 ]] #No values passed on call => print menu
then 
    clear 
    echo " _____           _____ _           "
    echo "|  |  |___ _____|   __| |___ _ _ _ "
    echo "|     | . |     |   __| | . | | | |"
    echo "|__|__|___|_|_|_|__|  |_|___|_____|"
    echo " Homlab                   @OleMiss" 
    echo " "
    echo " Build a pipeline...'go'"
    echo " Setup..............'s'"              
    echo " Help...............'h' "
    echo " Exit................ctrl + c "
    echo " "
    menu

else #Not working at all
    for var in ${@:3}
    do
		./$var.sh $1 $2
    done
    #control script
fi