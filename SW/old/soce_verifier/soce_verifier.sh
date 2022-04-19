#!/bin/bash

# SOURCES
source bash_functions/soce_bash_functions.sh

# GLOBAL VARIABLES
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# FUNCTIONS:

function helpPanel(){
	
        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Usage: ${yellowColour}./soce_verifier.sh -t <type> -r <input_file>${endColour} ${turquoiseColour}[ -f <data_filters> ] [ -w <type_out> <output_name> ]${endColour} "
        echo -e "\n    ${yellowColour}t) Type of analysis -> ixia_stats or pcap_file${endColour}"
        echo -e "    ${yellowColour}r) Input file (.stats or .pcap)${endColour}"
        echo -e "    ${turquoiseColour}f) Data filters as string "" [Optional]${endColour}"
        echo -e "    ${turquoiseColour}w) Only for pcap_file type: to export packets [Optional]${endColour}"		
        echo -e "    ${grayColour}h) Show this Help Panel${endColour}\n"
		#echo -e "${yellowColour}examples: ${endColour}${greenColour}\n./soce_verifier.sh -t pcap_file -r dump.pcap -f "vlan.id==100"\n./soce_test.sh -f recording_modes -t 1 -p 1 -c soce_cli -r\n./soce_test.sh -f igmp_snooping -b 0 -t 1 -p 1 -c soce_web -i file test_file.txt -r${endColour}\n"
        exit 0
}

function invalid_option(){
	print_error "Invalid option $OPTARG"
	exit 0
}

function missing_argument(){
	print_error "Option '$OPTARG' missing a required argument. "
	exit 0
}

function check_type(){

	if [ $1 != "ixia_stats" ] && [ $1 != "pcap_file" ] ; then
		print_error "Invalid option $OPTARG ( should be \"ixia_stats\" or \"pcap_file\" )"
		exit 0		
	fi	
}

# MAIN:

if [ "$(id -u)" == "0" ]; then

	filter=""

	declare -i parameter_counter=0; while getopts ":r:f:w:t:h" arg; do
			case $arg in
				t) type=$OPTARG ; check_type $type ; let parameter_counter+=1 ;;
				r) input_file=$OPTARG; let parameter_counter+=1 ;;
				f) filter=${OPTARG} ; filter_enabled="true" ;;
				w) type_out=$OPTARG ; shift $(($OPTIND - 1 )) ; output_file=$1 ; write_enabled="true" ;; 
				h) helpPanel;;
				:) missing_argument;;
				\?) invalid_option;;
			esac
	done

	if [ $parameter_counter -ne 2 ]; then
			helpPanel
	else

		if [ $type == "ixia_stats" ]; then

			print_info "IXIA_STATS option"
			tx_frames=$(cat $input_file | grep -P "\s+Tx Frames" | tr -s ":" | cut -d':' -f2 | tr -d " " | tr -d "\r")
			rx_frames=$(cat $input_file | grep -P "\s+Rx Frames" | tr -s ":" | cut -d':' -f2 | tr -d " " | tr -d "\r")
			tx_rate=$(cat $input_file | grep -P "\s+Tx Frame Rate" | tr -s ":" | cut -d':' -f2 | tr -d " " | tr -d "\r")
			rx_rate=$(cat $input_file | grep -P "\s+Rx Frame Rate" | tr -s ":" | cut -d':' -f2 | tr -d " " | tr -d "\r")
			loss=$(cat $input_file | grep -P "\s+Loss" | tr -s ":" | cut -d':' -f2 | tr -d " " | tr -d "\r")
			echo $loss $tx_frames

		elif [ $type == "pcap_file" ]; then
			print_info "PCAP_FILE option"
			if [ "${filter_enabled}" == "true" ]; then
				tshark -n -q -r $input_file -z io,stat,0," $filter"
				# tshark -n -q -r $input_file -z conv,eth," "	
			else
				tshark -n -q -r $input_file -z io,stat,0," "
				#tshark -n -q -r $input_file -z conv,eth," "
			fi
		fi
	fi	

else
        echo -e "\n${redColour}[*] Error: run this script as root user ${endColour}\n"
fi