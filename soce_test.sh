#!/bin/bash

trap ctrl_c INT
trap "file_no_colours; exit 1" TERM
export TOP_PID=$$

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour}Saliendo${endColour}"
	remove_tmp_vars
	file_no_colours
	rm -f *.cmd cmds/*.cmd
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

function check_config_type(){

	if [ $1 != "soce_cli" ] && [ $1 != "soce_web" ] && [ $1 != "netconf" ]; then
		print_error "Invalid option $OPTARG ( should be \"soce_cli\" or \"soce_web\" or \"netconf\"  )"
		exit 0		
	fi
}

function check_traffic_control(){
	if [ $1 != "start" ] && [ $1 != "stop" ] && [ $1 != "skip" ] && [ $1 != "clear" ] ; then
		print_error "Invalid option $OPTARG ( should be \"start\" or \"stop\" or \"skip\" or \"clear\" )"
		exit 0		
	fi
}

function check_debug_opt(){
	if [ $1 != "restore" ] && [ $1 != "config" ] && [ $1 != "traffic" ] && [ $1 != "verifier" ] && [ $1 != "all" ]; then
		print_error "Invalid option $OPTARG ( should be \"restore\" or \"config\" or \"traffic\" or \"verifier\" or \"all\" )"
		exit 0		
	else
		print_step "DEBUG MODE: $1" | tee -a $log_file
	fi
}

function add_tmp_vars(){

	echo "traffic_control=$traffic_control" >> platform.vars
	echo "test_function=$test_function" >> platform.vars
	echo "func=$func" >> platform.vars
	echo "port_0_config=$port_0_config" >> platform.vars
	echo "port_1_config=$port_1_config" >> platform.vars
	echo "port_2_config=$port_2_config" >> platform.vars
	echo "port_3_config=$port_3_config" >> platform.vars
	echo "config_type=$config_type" >> platform.vars
}

function remove_tmp_vars(){
	
	sed -i '/traffic_control=/d' platform.vars
	sed -i '/test_function=/d' platform.vars
	sed -i '/func=/d' platform.vars
	sed -i '/port_0_config=/d' platform.vars
	sed -i '/port_1_config=/d' platform.vars
	sed -i '/port_2_config=/d' platform.vars
	sed -i '/port_3_config=/d' platform.vars	
	sed -i '/config_type=/d' platform.vars
}

function helpPanel(){
	
        echo -e "\n${yellowColour}[*]${endColour}${grayColour} Usage: ${yellowColour}./soce_test.sh -f <functionality>${endColour} ${turquoiseColour}[-b <port_block>]${endColour} ${yellowColour}-t <test> -p <part> -c <config_DUT_through>${endColour} ${turquoiseColour}-d <debug_step> -s <id_func>${endColour}"
        echo -e "\n    ${yellowColour}f) Funcionality to test${endColour}"
        echo -e "    ${turquoiseColour}b) Port Block [Optional]${endColour}"
        echo -e "    ${yellowColour}t) Test to execute${endColour}"
        echo -e "    ${yellowColour}p) Part of the test (write 1 if there is only one part)${endColour}"
		echo -e "    ${yellowColour}c) DUT config : <soce_cli> or <soce_web> or <netconf>${endColour}"
		echo -e "    ${turquoiseColour}d) Debug specific STEP: <config> or <traffic> or <verifier> or <restore> [Optional]${endColour}"
		echo -e "    ${turquoiseColour}s) Special test adaptation: <id> [Optional]${endColour}"		
		# echo -e "    ${turquoiseColour}i) Input file/directory [Optional]${endColour}${endColour}"
		# echo -e "      file) <file path>"
		# echo -e "      dir)  <directory path>\n"
		# echo -e "    ${turquoiseColour}r) Generate Report File [Optional]${endColour}"
        echo -e "    ${grayColour}h) Show this Help Panel${endColour}\n"
		echo -e "${yellowColour}examples: ${endColour}${greenColour}\n./soce_test.sh -f vlan -b 0 -t 1 -p 1 -c soce_cli\n./soce_test.sh -f vlan -t 1 -p 1 -c soce_cli -d traffic\n./soce_test.sh -f vlan -b 0 -t 1 -p 1 -c soce_cli -s tsn_pcie${endColour}\n"
        exit 0
}


function verify_platform_vars(){

	sf_check_ping $ip 1; r=$?
	if [ $r -eq "0" ]; then
		print_error "DUT (${ip}) is not accesible. Check DUT's connectivity"
		kill -s TERM $TOP_PID		
	fi

	timeout 3 bash -c "</dev/tcp/$ip/22"
	if [ $? == 1 ];then
		print_error "SSH connection to $ip over port 22 is not possible"
		kill -s TERM $TOP_PID	
	fi	

	# Check user/password ssh/Web
	# Check interfaces IF1, IF2, If3...
	# Check $results_path
}


function send_input_files(){

	case $type_input in
		file)
			if [ -f "$input_file_dir" ]; then
				sshpass -p $password scp -o StrictHostKeyChecking=no -r "$input_file_dir" $username@$ip:/home/$username/
			fi
		;;
		dir)
			if [ -d "$input_file_dir" ]; then
				sshpass -p $password scp -o StrictHostKeyChecking=no -r "$input_file_dir" $username@$ip:/home/$username/
			fi
		;;
	esac	
}

function remove_input_files(){

	case $type_input in
		file)
			sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "rm $(basename $input_file_dir)"
		;;
		dir)
			sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "rm -r $(basename $input_file_dir)"
		;;
	esac
}

debug () [[ -v dtype ]]

function debug_stop(){

	
	if [ $1 == "all" ]; then
		print_debug && read
	elif [ $1 == "restore" ] || [ $1 == "config" ] || [ $1 == "traffic" ] || [ $1 == "verifier" ]  ; then
		echo -e "\n${yellowColour}[*]${endColour}${grayColour}Saliendo${endColour}" | tee -a $log_file
		remove_tmp_vars
		file_no_colours
		rm -f *.cmd cmds/*.cmd
		exit 0		
	fi
}

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}


# ***************************************************************************************************************************
# Main Function
# ***************************************************************************************************************************

if [ "$(id -u)" == "0" ]; then

	source bash_functions/soce_bash_functions.sh > /dev/null 2>&1

	if sf_fn_exists $1; then 

		${@:1} && exit 0
	fi

	# Log file:
	log_file="logs/soce_test_$(date +"%Y_%m_%d_%H_%M_%S").log"
	mkdir -p logs/old ; cp logs/*.log logs/old  > /dev/null 2>&1 ; rm -f logs/*.log ; mkdir -p cmds
	block=0 ; type_input="none" ; config_type="none"; dtype="start"; id_special="none";
	traffic_control="none"
	declare -i parameter_counter=0; while getopts ":f:b:t:p:hi:rc:d:s:" arg; do
			case $arg in
				f) func=$OPTARG; let parameter_counter+=1 ;;
				b) block=$OPTARG ;;
				t) test=$OPTARG; let parameter_counter+=1 ;;
				p) part=$OPTARG; let parameter_counter+=1 ;;
				h) helpPanel;;
				r) REPORT=true ; mkdir -p "REPORTS/${func}" ;;
				i) type_input=$OPTARG ; shift $(($OPTIND - 1 )) ; input_file_dir=$1 ;;
				c) config_type=$OPTARG ; check_config_type $config_type ;;
				d) dtype=$OPTARG ; check_debug_opt $dtype ;;
				#s) traffic_control=$OPTARG ; check_traffic_control $traffic_control ;;
				s) id_special=$OPTARG ;;
				:) missing_argument;;
				\?) invalid_option;;
			esac
	done

	# More information about getopts: https://www.it-swarm-es.com/es/bash/usando-getopts-para-procesar-opciones-de-linea-de-comando-largas-y-cortas/958154021/

	if [ $parameter_counter -ne 3 ]; then
			helpPanel
	else
		printf "${blueColour}./soce_test.sh $(echo $@)${endColour}"  | tee -a $log_file
		#*************************************************************************************
		# INIT SOCE_TEST:
		#*************************************************************************************
		print_step "STEP 1 - INIT SOCE_TEST" | tee -a $log_file
		echo -e "${yellowColour}[*]${endColour}${grayColour} Reading platform.vars${endColour}" | tee -a $log_file

		source platform.vars
		# source all CONFIG/* files:
		for f in DUT_CONFIG_CLI/*; do source $f; done > /dev/null 2>&1
		for f in PRE_CONFIG/*; do source $f; done > /dev/null 2>&1
		for f in VERIFIER/*.sh; do source $f; done > /dev/null 2>&1

		print_info "DUT --> [IP=$ip] [Model=$model] [Version=$version]"

		# Verify connectivity and dependencies:
		verify_platform_vars | tee -a $log_file
		check_dependencies | tee -a $log_file

		# Create report_stamp:
		ssh-keygen -R $ip > /dev/null 2>&1
		rm -f REPORTS/report_stamp.txt && ( read_report_info > REPORTS/report_stamp.txt ; sed -i '/^\(|\)/!d' REPORTS/report_stamp.txt; ) > /dev/null 2>&1

		# Input arguments decoder:
		test_function="test_${func}_${test}_${part}"
		test_function_restore="test_${func}_${test}_${part}_restore"
		test_function_pre_config="test_${func}_${test}_${part}_pre_config"
		test_function_pre_config_restore="test_${func}_${test}_${part}_pre_config_restore"
		test_function_verifier="test_${func}_${test}_${part}_verifier"

		port_0_config="port_$(($(($block*4))+0))_name"
		port_1_config="port_$(($(($block*4))+1))_name"
		port_2_config="port_$(($(($block*4))+2))_name"
		port_3_config="port_$(($(($block*4))+3))_name"

		port_0_config=${!port_0_config}
		port_1_config=${!port_1_config}
		port_2_config=${!port_2_config}
		port_3_config=${!port_3_config}	

		# File Transfer management ( -i file/dir ):
		send_input_files

		#rm -r REPORTS/${func}/* > /dev/null 2>&1

		start=${dtype:-"start"}
		jumpto $start
start:
all:
		#*************************************************************************************
		# Restore DUT config :
		#*************************************************************************************
		print_step "STEP 2 - RESTORE DUT CONFIG" | tee -a $log_file
		if [ $config_type == "soce_cli" ] || [ $config_type == "netconf" ]; then 	# TEMPORAL: netconf restore option !!!

			if sf_fn_exists "${test_function_restore}_${id_special}"; then

				print_info "Executing [DUT_CONFIG_CLI/${func}_cli.conf] \"${test_function_restore}_${id_special}\" function (soce_cli)" | tee -a $log_file
				${test_function_restore}_${id_special} | tee -a $log_file
				sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < cmds/${test_function}_dut_config_restore.cmd | tee -a $log_file

			else		

				if ! sf_fn_exists $test_function_restore; then
					print_warning "No DUT restore configuration file (soce_cli)." | tee -a $log_file
				else
					print_info "Executing [DUT_CONFIG_CLI/${func}_cli.conf] \"$test_function_restore\" function (soce_cli)" | tee -a $log_file
					$test_function_restore | tee -a $log_file
					sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < cmds/${test_function}_dut_config_restore.cmd | tee -a $log_file
					#debug_stop
				fi
			fi

		elif [ $config_type == "soce_web" ]; then 
			cd DUT_CONFIG_WEB

			if [ -f "${func}/${test_function_restore}_${id_special}.js" ]; then
				print_info "Executing DUT_CONFIG_WEB/${func}/${test_function_restore}_${id_special}.js Selenium script (soce_web)" | tee -a $log_file
				cd ../
				sbf_platform_to_constants > /dev/null 2>&1
				cd DUT_CONFIG_WEB
				su -c "node ${func}/${test_function_restore}_${id_special}.js" $user_host 

			else

				if [ -f "${func}/${test_function_restore}.js" ]; then
					print_info "Executing DUT_CONFIG_WEB/${func}/${test_function_restore}.js Selenium script (soce_web)" | tee -a $log_file
					cd ../
					sbf_platform_to_constants > /dev/null 2>&1
					cd DUT_CONFIG_WEB
					su -c "node ${func}/${test_function_restore}.js" $user_host 
				else 
					print_warning "No DUT restore configuration (soce_web)."
				fi
			fi
			cd ..
		fi

		debug_stop $dtype

		#*************************************************************************************
		# PRE-CONFIG :
		#*************************************************************************************
		print_step "STEP 3 - PRE-CONFIG" | tee -a $log_file	
		
		if sf_fn_exists "${test_function_pre_config}_${id_special}"; then

			print_info "Executing PRE_CONFIG/$test_function_pre_config.sh script" | tee -a $log_file
			${test_function_pre_config}_${id_special} | tee -a $log_file

		else		

			if sf_fn_exists $test_function_pre_config; then
				print_info "Executing PRE_CONFIG/${test_function_pre_config}_${id_special}.sh script" | tee -a $log_file
				${test_function_pre_config} | tee -a $log_file
				#sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < cmds/${test_function}.cmd | tee -a $log_file
				#debug_stop
			else
				print_warning "No PRE-CONFIG script" | tee -a $log_file
			fi
		fi

config:
		#*************************************************************************************
		# DUT config :
		#*************************************************************************************
		print_step "STEP 4 - DUT CONFIG" | tee -a $log_file
		rm -f /usr/local/start
		if [ $config_type == "soce_cli" ] || [ $config_type == "netconf" ]; then 	# TEMPORAL: netconf config option !!!

			if sf_fn_exists "${test_function}_${id_special}"; then
				print_info "Executing function \"${test_function}_${id_special}\" [DUT_CONFIG_CLI/${func}_cli.conf] (soce_cli)" | tee -a $log_file

				if [ -f DUT_CONFIG_CLI/JSON/$func/${test_function}_${id_special}.json ]; then
					print_info "\tSending DUT_CONFIG_CLI/JSON/$func/${test_function}_${id_special}.json to the DUT (/home/$username/)" | tee -a $log_file
					sshpass -p $password scp -o StrictHostKeyChecking=no -r DUT_CONFIG_CLI/JSON/$func/${test_function}_${id_special}.json $username@$ip:/home/$username/
				else

					if [ -f DUT_CONFIG_CLI/JSON/$func/${test_function}.json ]; then
						print_info "\tSending DUT_CONFIG_CLI/JSON/$func/${test_function}.json to the DUT (/home/$username/)" | tee -a $log_file
						sshpass -p $password scp -o StrictHostKeyChecking=no -r DUT_CONFIG_CLI/JSON/$func/${test_function}.json $username@$ip:/home/$username/
					fi
				
				fi

				${test_function}_${id_special} | tee -a $log_file
				sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < cmds/${test_function}_dut_config.cmd | tee -a $log_file
				sudo touch /usr/local/start
				#debug_stop

				if [ -f DUT_CONFIG_CLI/JSON/$func/${test_function}_${id_special}.json ]; then
						print_info "\tRemoving /home/$username/${test_function}_${id_special}.json from the DUT" | tee -a $log_file
						sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "rm ${test_function}_${id_special}.json"
				else

					if [ -f DUT_CONFIG_CLI/JSON/$func/${test_function}.json ]; then
						print_info "\tRemoving /home/$username/${test_function}.json from the DUT" | tee -a $log_file
						sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "rm $test_function.json"
					fi
				
				fi				

			else			

				if ! sf_fn_exists $test_function; then
					print_warning "No DUT configuration file (soce_cli)." | tee -a $log_file
					sudo touch /usr/local/start
				else
					print_info "Executing function \"$test_function\" [DUT_CONFIG_CLI/${func}_cli.conf] (soce_cli)" | tee -a $log_file

					if [ -f DUT_CONFIG_CLI/JSON/$func/$test_function.json ]; then
						print_info "\tSending DUT_CONFIG_CLI/JSON/$func/${test_function}.json to the DUT (/home/$username/)" | tee -a $log_file
						sshpass -p $password scp -o StrictHostKeyChecking=no -r DUT_CONFIG_CLI/JSON/$func/${test_function}.json $username@$ip:/home/$username/
					fi

					$test_function | tee -a $log_file
					sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < cmds/${test_function}_dut_config.cmd | tee -a $log_file
					sudo touch /usr/local/start
					#debug_stop

					if [ -f DUT_CONFIG_CLI/JSON/$func/$test_function.json ]; then
						print_info "\tRemoving /home/$username/${test_function}.json from the DUT" | tee -a $log_file
						sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "rm $test_function.json"
					fi

				fi
			fi

		elif [ $config_type == "soce_web" ]; then 
			cd DUT_CONFIG_WEB

			if [ -f "${func}/${test_function}_${id_special}.js" ]; then
				cd ../
				print_info "Executing DUT_CONFIG_WEB/${func}/${test_function}_${id_special}.js Selenium script (soce_web)" | tee -a $log_file
				sbf_platform_to_constants > /dev/null 2>&1
				cd DUT_CONFIG_WEB
				su -c "node ${func}/${test_function}_${id_special}.js" $user_host &
			else
				if [ -f "${func}/${test_function}.js" ]; then
					cd ../
					print_info "Executing DUT_CONFIG_WEB/${func}/${test_function}.js Selenium script (soce_web)" | tee -a $log_file
					sbf_platform_to_constants > /dev/null 2>&1
					cd DUT_CONFIG_WEB
					su -c "node ${func}/${test_function}.js" $user_host &
				else 
					print_warning "No DUT configuration (soce_web)." | tee -a $log_file
				fi
			fi
			cd ..		
		fi

		if [ $config_type == "netconf" ]; then 
			cd DUT_CONFIG_NETCONF

			if [ -f "${func}/${test_function}_${id_special}.xml" ]; then
				print_info "Executing edit-config command with DUT_CONFIG_NETCONF/${func}/${test_function}_${id_special}.xml (netconf)" | tee -a ../$log_file
				netconf-console2 --port 830 --host $ip -u $username -p $password --db=running "${func}/${test_function}_${id_special}.xml"  | tee -a ../$log_file
			else
				if [ -f "${func}/${test_function}.xml" ]; then
					print_info "Executing edit-config command with DUT_CONFIG_NETCONF/${func}/${test_function}.xml (netconf)" | tee -a ../$log_file
					netconf-console2 --port 830 --host $ip -u $username -p $password --db=running "${func}/${test_function}.xml"  | tee -a ../$log_file
				else 
					print_warning "No DUT configuration XML (netconf)." | tee -a ../$log_file
				fi
			fi
			cd ..			
		fi		

		debug_stop $dtype

traffic:
		#*************************************************************************************
		# SOCE_GENERATOR / IXIA / CUSTOM SCAPY SW:
		#*************************************************************************************
		print_step "STEP 5 - SG / IXIA / CUSTOM APP" | tee -a $log_file
		if [ -f "SG_FLOWS/${func}/${test_function}_${id_special}.sh" ]; then
			
			print_info "Executing SG / IXIA / CUSTOM APP software. Check script -> [SG_FLOWS/${func}/${test_function}_${id_special}.sh]" | tee -a $log_file
			add_tmp_vars
			echo $password | sudo -S ./SG_FLOWS/${func}/"${test_function}_${id_special}.sh" | tee -a $log_file
			remove_tmp_vars
			#debug_stop
		else
			if [ -f "SG_FLOWS/${func}/${test_function}.sh" ]; then
				
				print_info "Executing SG / IXIA / CUSTOM APP software. Check script -> [SG_FLOWS/${func}/${test_function}.sh]" | tee -a $log_file
				add_tmp_vars
				echo $password | sudo -S ./SG_FLOWS/${func}/"${test_function}.sh" | tee -a $log_file
				remove_tmp_vars
				#debug_stop
			else 
				print_warning "No SOCE_GENERATOR script ( SG_FLOWS/${func}/${test_function}.sh does not exist. )" | tee -a $log_file
			fi
		fi
		# until [ -f /usr/local/start ]
		# do
		# 	sleep 1
		# done
		
		debug_stop $dtype

verifier:

		#*************************************************************************************
		# VERIFIER:
		#*************************************************************************************
		print_step "STEP 6 - VERIFIER" | tee -a $log_file
		if sf_fn_exists "${test_function_verifier}_${id_special}"; then
			print_info "Executing VERIFIER/${func}_verifier.sh [function ${test_function_verifier}_${id_special}] script" | tee -a $log_file
			${test_function_verifier}_${id_special} | tee -a $log_file
			#debug_stop
		else
			if sf_fn_exists $test_function_verifier; then
				print_info "Executing VERIFIER/${func}_verifier.sh [function ${test_function}_verifier] script" | tee -a $log_file
				$test_function_verifier | tee -a $log_file
				#debug_stop
			else
				print_warning "No VERIFIER script"
			fi
		fi

		debug_stop $dtype

restore:
		#*************************************************************************************
		# Restore DUT config :
		#*************************************************************************************
		print_step "STEP 7 - RESTORE DUT CONFIG" | tee -a $log_file
		if [ $config_type == "soce_cli" ] || [ $config_type == "netconf" ]; then 	# TEMPORAL: netconf restore option !!!

			if sf_fn_exists "${test_function_restore}_${id_special}"; then

				print_info "Executing [DUT_CONFIG_CLI/${func}_cli.conf] \"${test_function_restore}_${id_special}\" function (soce_cli)" | tee -a $log_file
				${test_function_restore}_${id_special} | tee -a $log_file
				sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < cmds/${test_function}_dut_config_restore.cmd | tee -a $log_file

			else		

				if ! sf_fn_exists $test_function_restore; then
					print_warning "No DUT restore configuration file (soce_cli)." | tee -a $log_file
				else
					print_info "Executing [DUT_CONFIG_CLI/${func}_cli.conf] \"$test_function_restore\" function (soce_cli)" | tee -a $log_file
					$test_function_restore | tee -a $log_file
					sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < cmds/${test_function}_dut_config_restore.cmd | tee -a $log_file
					#debug_stop
				fi
			fi

		elif [ $config_type == "soce_web" ]; then 
			cd DUT_CONFIG_WEB

			if [ -f "${func}/${test_function_restore}_${id_special}.js" ]; then
				print_info "Executing DUT_CONFIG_WEB/${func}/${test_function_restore}_${id_special}.js Selenium script (soce_web)" | tee -a $log_file
				cd ../
				sbf_platform_to_constants > /dev/null 2>&1
				cd DUT_CONFIG_WEB
				su -c "node ${func}/${test_function_restore}_${id_special}.js" $user_host 

			else

				if [ -f "${func}/${test_function_restore}.js" ]; then
					print_info "Executing DUT_CONFIG_WEB/${func}/${test_function_restore}.js Selenium script (soce_web)" | tee -a $log_file
					cd ../
					sbf_platform_to_constants > /dev/null 2>&1
					cd DUT_CONFIG_WEB
					su -c "node ${func}/${test_function_restore}.js" $user_host 
				else 
					print_warning "No DUT restore configuration (soce_web)."
				fi
			fi
			cd ..
		fi

		debug_stop $dtype

		#*************************************************************************************
		# PRE-CONFIG RESTORE:
		#*************************************************************************************
		print_step "STEP 8 - PRE-CONFIG_restore" | tee -a $log_file	
		if sf_fn_exists "${test_function_pre_config_restore}_${id_special}"; then
			print_info "Executing PRE_CONFIG/${test_function_pre_config_restore}_${id_special}.sh script" | tee -a $log_file
			${test_function_pre_config_restore}_${id_special} | tee -a $log_file
		else
			if sf_fn_exists $test_function_pre_config_restore; then
				print_info "Executing PRE_CONFIG/${test_function_pre_config_restore}.sh script" | tee -a $log_file
				$test_function_pre_config_restore | tee -a $log_file
			else
				print_warning "No PRE-CONFIG script"
			fi
		fi

		#export_results
		#file_no_colours

		# Clear aux files 
		remove_input_files
		rm -f *.cmd cmds/*.cmd
		exit 0

	fi

else
        echo -e "\n${redColour}[*] Error: run this script as root user ${endColour}\n"
fi
