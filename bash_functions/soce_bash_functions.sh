#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Independent auxiliar functions:
# Usage: ./soce_test <aux_function>
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function check_dependencies(){

    # Ensure that las line is empty
    if [ "$(tail -1 bash_functions/dependencies_soce_test.list)" != "" ]; then
        echo "" >> bash_functions/dependencies_soce_test.list
    fi

    # Basic method to check Internet connectivity
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
    if ! [ $? -eq 0 ]; then
        print_error "Please check for Internet connectivity."
        exit 0
    fi

    OLDIFS=$IFS
    IFS=","
    while read installer_ command_ package_
    do
        if [ "$installer_" != INSTALLER ] && [ "$installer_" != "" ]; then
            # print_info "$installer_ $command_ $package_"
            sleep 0.05
            echo -ne "\n${blueColour}[*] Tool${endColour}${purpleColour} $command_${endColour}${blueColour}...${endColour}"
            if [ "$installer_" == "apt" ]; then
                if ! ( which $command_ > /dev/null ); then
				    echo -e " ${redColour}(X)${endColour}\n"
				    echo -e "${yellowColour}[*]${endColour}${grayColour} Installing tool ${endColour}${blueColour}$package_${endColour}${yellowColour}...${endColour}"
                    echo $password | sudo -S apt-get install $package_ -y > /dev/null 2>&1
                    if ! ( which $command_ > /dev/null ); then
                        print_warning "Package $package_ is not correctly installed. Execute <sudo apt-get update> or try to install manually..."
                    fi
                else
                    echo -e " ${greenColour}(V)${endColour}"
                fi
            elif [ "$installer_" == "pip3" ]; then
                if ! ( which $command_ > /dev/null ); then
				    echo -e " ${redColour}(X)${endColour}\n"
				    echo -e "${yellowColour}[*]${endColour}${grayColour} Installing tool ${endColour}${blueColour}$package_${endColour}${yellowColour}...${endColour}"
                    echo $password | sudo -S pip3 install $package_  > /dev/null 2>&1
                    if ! ( which $command_ > /dev/null ); then
                        print_warning "Package $package_ is not correctly installed. Execute <sudo apt-get update> or try to install manually..."
                    fi                    
                else
                    echo -e " ${greenColour}(V)${endColour}"
                fi            
            elif [ "$installer_" == "pip" ]; then
                if ! ( which $command_ > /dev/null ); then
				    echo -e " ${redColour}(X)${endColour}\n"
				    echo -e "${yellowColour}[*]${endColour}${grayColour} Installing tool ${endColour}${blueColour}$package_${endColour}${yellowColour}...${endColour}"
                    echo $password | sudo -S pip install $package_  > /dev/null 2>&1
                    if ! ( which $command_ > /dev/null ); then
                        print_warning "Package $package_ is not correctly installed. Execute <sudo apt-get update> or try to install manually..."
                    fi                    
                else
                    echo -e " ${greenColour}(V)${endColour}"
                fi              
            else
                print_error "INSTALLER [$installer_] not found"
            fi
        fi
    done < bash_functions/dependencies_soce_test.list #> /dev/null 2>&1 
    IFS=$OLDIFS      
}

# This function will print csv VERIFIER
function print_csv(){

    mlr --icsv --opprint cat $1
}

# This function will provide appropiate permissions to all files of SOCE_TEST
function init(){

    find . -type d -exec chmod 777 {} \;
    find . -type f -exec chmod 666 {} \;
    find . -name "*.sh" -execdir chmod u+x {} +
}

# This function will clean old logs (folder SOCE_TEST/logs/old/*)
function clean(){

    print_info "Removing old logs..."
    rm -r logs/old > /dev/null 2>&1
    print_info "Removing all fixes from FILES_EXCHANGE/testing_fixes/"
    rm -r FILES_EXCHANGE/testing_fixes/*.bin > /dev/null 2>&1
    rm -r FILES_EXCHANGE/testing_fixes/*.zip > /dev/null 2>&1
    exit 0
}

# This function will automatically generate a testing fix for device described in platform.vars. This patch will also install EDSA scapy tool for DUT and packages required by this tool
# The testing fix will be saved in FILES_EXCHANGE/testing_fixes/
function gen_testing_fix(){

source platform.vars

ssh-keygen -R $ip > /dev/null 2>&1
sshpass -p $password scp -o StrictHostKeyChecking=no -r SW/edsa $username@$ip:/home/$username/
sshpass -p $password ssh -t -o StrictHostKeyChecking=no  $username@$ip "
rm -r tmp > /dev/null 2>&1
echo $password | sudo -S mount /dev/mmcblk0p1 /mnt/
mkdir tmp
cp /mnt/* tmp/
echo $password | sudo -S umount /mnt/
cd tmp
mkdir home && mkdir home/$username/
cp -r ../edsa home/$username/
rm -r ../edsa
echo \"touch /mnt/mmc1/preupdate_test.txt\" > preupdate.cmd
echo \"touch /update_test.txt\" > update.cmd
echo \"apt-get install -y net-tools stress screen tcpdump tcpreplay python3-pip
pip3 install scapy\" > update.cmd
mkdir test_dir
echo \"Testing...\" > test_dir/test_file.txt
tar --remove-files -cf update.tar test_dir/ home/
zip -mj fix_testing_image_${model}_${version}.zip *
"
sshpass -p $password scp -o StrictHostKeyChecking=no $username@$ip:/home/$username/tmp/fix_testing_image_${model}_${version}.zip FILES_EXCHANGE/testing_fixes/

cd FILES_EXCHANGE/testing_fixes/
./generate_dig_sign.sh fix_testing_image_${model}_${version}.zip $sign_key $certificate_dst fix_testing_image_${model}_${version}.bin
cd ../..
}

function upload_results(){

if [ "$#" -ne 1 ]; then
    print_info "Function usage: ./soce_test upload_results <functionality>\nType * to upload all functionality results\n"
    exit 0
else
    source platform.vars

    mkdir -p 
    cp ${tmp_results}/${model}/${version}/

fi

}


# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Auxiliar functions for Test develop
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Usage: fast_ssh_cmds <cmds(string)> <-r> 
function fast_ssh_cmds(){

echo "$1" > cmds/fast_ssh_cmds.txt

tail -c +2 cmds/fast_ssh_cmds.txt > change && mv change cmds/fast_ssh_cmds.txt
sed -i '$ d' cmds/fast_ssh_cmds.txt # remove last line (\n)

if [[ $2 == "-r" ]] ; then
echo $1 > cmds/fast_ssh_cmds
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
$(cat cmds/fast_ssh_cmds.txt)
" | tee -a REPORTS/${func}/${test_function}.out
else
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
$(cat cmds/fast_ssh_cmds.txt)
"
fi
rm -r cmds/fast_ssh_cmds.txt > /dev/null 2>&1
}

# Usage: fast_soce_cli <cmds(string)> <-r> 
function fast_soce_cli(){

echo "$1" > cmds/fast_soce_cli.txt

tail -c +2 cmds/fast_soce_cli.txt > change && mv change cmds/fast_soce_cli.txt
# #sed -i '/^$/d' cmds/fast_soce_cli # remove all \n (NOK)
sed -i '$ d' cmds/fast_soce_cli.txt # remove last line (\n)

if [[ $2 == "-r" ]] ; then
echo $1 > cmds/fast_soce_cli
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
$(cat cmds/fast_soce_cli.txt)
EOF
" | tee -a REPORTS/${func}/${test_function}.out
else
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
$(cat cmds/fast_soce_cli.txt)
EOF
"
fi
rm -r cmds/fast_soce_cli.txt > /dev/null 2>&1
}

# Usage: config_speed_ifaces <speed> {list of interfaces}
function config_speed_ifaces(){

    speed=$1

    for iface in "${@:2}"
    do
        current_speed=$(cat /sys/class/net/${iface}/speed)
        if [ $current_speed -ne $speed ]; then
            ip link set $iface down
            ethtool -s $iface speed $speed duplex full autoneg on
            ip link set $iface up
        fi
    done
    sleep 0.5
    # Wait until link is up:
    for IF in "${@:2}"
    do
            echo -ne "\nInterface $IF..."
            timeout 5 bash -c -- "while true; do if ethtool ${IF} | grep -q 'Link detected: yes'; then printf ' is UP'; break; fi; done"
    done
    printf "\n"
    sleep 10
}


# ------------------------------------------------------------------------------------------------------------------------------------------------

# Usage: print_debug <Message>
function print_debug(){
    echo -e "${grayColour}\n++++++++++++++++++++++++++++++++++++++++++++++++++++${endColour}"
    #echo -e "${grayColour}\tDEBUG MODE: ${1} ${endColour}"
    echo -e "${grayColour}[+] Debug: Press Enter to continue to the next step ${endColour}"
    echo -e "${grayColour}++++++++++++++++++++++++++++++++++++++++++++++++++++${endColour}"
}

# Usage: print_info <Message>
function print_info(){
    echo -e "${greenColour}[+] Info: ${1} ${endColour}"
}

# Usage: print_error <Message>
function print_error(){
    echo -e "${redColour}[*] Error: ${1} ${endColour}"
}

# Usage: print_warning <Message>
function print_warning(){
    echo -e "${yellowColour}[-] Warning: ${1} ${endColour}"
}

# Usage: print_step <Message>
function print_step(){
    echo -e "\n${blueColour}
[---------------------------------------------]
\t${1}
[---------------------------------------------] 
${endColour}"
sleep 0.5
}

# ------------------------------------------------------------------------------------------------------------------------------------------------

# Usage example:
#
#if ! sf_fn_exists $test_function_restore; then
#    printf "Warning: No DUT restore configuration (soce_cli).\n"  
#fi
sf_fn_exists() {
  [ `type -t $1`"" == 'function' ]
}


# Not available !!!!
function xterm_cmd(){
print_info "$1"
xterm -hold -e "$1" &    
: '
xterm -title "Syslog Server" -hold -e "sshpass -p $password_server ssh -t -o StrictHostKeyChecking=no  $user_server@$ip_server \"
echo $password_server | sudo -S systemctl stop syslog-ng
echo $password_server | sudo -S /usr/sbin/syslog-ng -Fdev 2>&1 | tee /var/log/server.log
\"
" &
'
}



# Usage example:
#
#sf_check_ping 192.168.2.128 1; r=$?
#echo $r -> 1: ping / 0: no ping

function sf_check_ping(){ # $1: ip , $2: N, $3: P

local ip=$1
local N=$2
if [ $3 ]; then P="True" ; fi

for i in $(seq 1 ${N})
do
    sleep 0.1
    p_bar && ProgressBar ${i} ${N}
    ping -c 1 $ip > /dev/null 2>&1 
    rc=$?
    if [[ $rc -eq 0 ]] ; then
        return 1               
    fi    
done
return 0

}

# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}

p_bar () [[ -v P ]]

# This function will create a copy of log file (SOCE_TEST/logs/*.log) without colours text. Useful for export report files (.log or .out)
function file_no_colours(){

    cat logs/*.log | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" > "logs/nc_soce_test_$(date +"%Y_%m_%d_%H_%M_%S").log"

    if [[ $# -eq 1 ]] ; then
        
        if [[ -f $1 ]] ; then
            cat $1 | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" > /tmp/fnc.txt && mv /tmp/fnc.txt $1
        
            sed '/^*/d' $1 > change && mv change $1
            #sed '/^\rsoce_cli#/d' $1 > change && mv change $1
        fi
    fi

}

# This function will provide report_stamp information:
function read_report_info(){
printf "
|****************************SOCE_TEST REPORT************************************|
| Tested by\t:\t$TestedBy
| Date\t\t:\t$(date)
|********************************************************************************|
"
dut_config="get_info_DUT"
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli << EOF
sys_info get
EOF
"
echo "
| HPS:
"
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli << EOF
fpga_info get_core_version HPS
EOF
"
echo "
| SWITCH:
"
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli << EOF
fpga_info get_core_version SWITCH
EOF
"
echo "
|
|****************************SOCE_TEST REPORT************************************|
"
}

# This function will add the report_stamp to report file
# Usage: set_report_info <file_input>
function set_report_info(){

rm -f /tmp/tmp.txt
{ cat REPORTS/report_stamp.txt; cat $1; } > /tmp/tmp.txt && mv /tmp/tmp.txt $1

chmod 666 $1

}


# This function will send reports files to $results_path (NAS results path, platforma.vars)
# Files to send (if exists):
    # VERIFIER/Report/$config_type/${func}/${test_function}*.pcap
    # logs/nc_soce_test_*.log 
    # REPORTS/${func}/${test_function}.out 
    # REPORTS/${func}/${test_function}.stats
    # REPORTS/${func}/${test_function}.pcap
function export_results(){

    current=$(pwd)
    cd "${tmp_results}/${model}/${version}/"
    mkdir -p ${func}
    cd $current
    file_no_colours


    declare -a files_to_export=(
        VERIFIER/Report/$config_type/${func}/${test_function}/${test_function}*.pcap
        VERIFIER/Report/$config_type/${func}/${test_function}*.pcap
        logs/nc_soce_test_*.log 
        REPORTS/${func}/${test_function}*.out 
        REPORTS/${func}/${test_function}*.stats
        REPORTS/${func}/${test_function}*.pcap
        REPORTS/${func}/${test_function}*.rpt
    )

    if [[ "$id_special" == "none" ]] ; then id_export=""; else id_export="_${id_special}"; fi


    for fd in "${files_to_export[@]}"
    do
        if [[ -f $fd ]] ; then

            if  [[ $fd == *.log  ]] ; then
    
                set_report_info $fd
                #cp  -r $fd "${results_path}/${func}/${test_function}.log"
                mkdir -p "${tmp_results}/${model}/${version}/${func}"
                cp  -r $fd "${tmp_results}/${model}/${version}/${func}/${test_function}${id_export}.log"

            elif [[ $fd == *.rpt ]] ; then

                set_report_info $fd
                mkdir -p "${tmp_results}/${model}/${version}/${func}"
                cp  -r $fd "${tmp_results}/${model}/${version}/${func}/${test_function}${id_export}.rpt" 

            elif [[ $fd == *.out ]] ; then
                
                file_no_colours $fd
                set_report_info $fd
                #cp  -r $fd "${results_path}/${func}/${test_function}.out"
                mkdir -p "${tmp_results}/${model}/${version}/${func}"
                cp  -r $fd "${tmp_results}/${model}/${version}/${func}/${test_function}${id_export}.out" 

            elif [[ $fd == *.stats ]] ; then

                file_no_colours $fd
                set_report_info $fd
                #cp  -r $fd "${results_path}/${func}/${test_function}.stats"
                mkdir -p "${tmp_results}/${model}/${version}/${func}"
                #cp  -r $fd "${tmp_results}/${model}/${version}/${func}/${test_function}.stats" 
                cp  -r $fd "${tmp_results}/${model}/${version}/${func}" 

  
            else
                mkdir -p "${tmp_results}/${model}/${version}/${func}"
                cp -r $fd "${tmp_results}/${model}/${version}/${func}"

            fi
        fi
    done

}


# This function converts platform.vars to constants.json

function sbf_platform_to_constants(){

rm -f tmp.*

grep -F '=' platform.vars > tmp.json # filtrarte las variables

sed -i 's/^/"/' tmp.json
sed -i 's/$/",/' tmp.json
sed -i 's/=/":"/g' tmp.json
sed -i 's/""/"/g' tmp.json
sed -i 's/\/\\/g' tmp.json # NOK [replace \ -> \\] path
sed -i '1s/^/{\n/' tmp.json
sed -i '$s/,//' tmp.json

echo "}" >> tmp.json

cp tmp.json DUT_CONFIG_WEB/constants.json

rm -f tmp.*


}


function append_Results_csv(){

    file=$1
    title=$2
    local -n array=$3

    i=0
    rm -f cmds/output.csv

    while IFS="" read -r p || [ -n "$p" ]
    do
            [ "$i" == "0" ] && echo "$p,$title" >> cmds/output.csv
            [ "$i" != "0"  ] && echo "$p,${array[$((i-1))]}" >> cmds/output.csv 
            i=$((i+1))
    done < $file

    mv cmds/output.csv $file
    rm -f cmds/output.csv

}

#https://stackoverflow.com/questions/10582763/how-to-return-an-array-in-bash-without-using-globals
function get_stat_field(){

    # Filter File: Fix grep search (conflict "Frames Tx." <--> "Scheduled Frames Tx.")
    if [ "$2" == "Frames Tx." ] || [ "$2" == "Frames Tx. Rate" ] ; then
        cat $1 | grep -v "Scheduled" > cmds/tmp
    else
        cp $1 cmds/tmp > /dev/null 2>&1
    fi

    local -n array=$3
    while read -r line ; do
        #echo -e "[$line]"
        array=( "${array[@]}" "$line" )
    # done < <(grep -oP "$2\s*:\s*\K.*" $1) 
    done < <(grep -oP "$2\s*: \K.*" cmds/tmp) 

    rm -f cmds/tmp > /dev/null 2>&1
}


# This function will import Port/Flow Statistics generated by Ixia VM (soce@192.168.2.146)
# Usage: import_ixia_stats <remote_file> <local_file>
function import_ixia_stats(){

    #remote_test_folder="c:\\test\\reports\\${test_function}\\"     # TO DO: define a dedicated folder in remote VM
    
    remote_path_filename_stats=$1

    local_path_filename_stats=$2

    sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:$remote_path_filename_stats $local_path_filename_stats

    fix_ixia_stats_file $local_path_filename_stats

}

function fix_ixia_stats_file(){

    # Fix format file
    dos2unix $1 > /dev/null 2>&1

    # Remove "()" from file
    sed -i "s/(//gi" $1
    sed -i "s/)//gi" $1

}

function analyze_results_stats(){

    # echo $1
    #file_to_analyze=$1
    file_csv=$1

    sed -i '/^$/d' $file_csv
    dos2unix $file_csv > /dev/null 2>&1

    declare -a array_flow_group=()
    declare -a array_results=()
    declare -a array_verifier=()
    declare -a array_stats=()

    # tmp_pcap=VERIFIER/Report/$config_type/${func}/${test_function}_tmp.pcap
    # mkdir -p "${tmp_pcap%/*}" && touch $tmp_pcap
    # cat $file_csv
    OLDIFS=$IFS
    IFS=","
    while read filename flowN_stats description_stats field_stats accur_stats expected_stats
    do
        if [ -f $filename ] && [ "$filename" != Filename ] ; then
            array_stats=( "${array_stats[@]}" "$(basename ${filename})" )
            if [ "$accur_stats" == "*" ] ; then

                #echo $filename
                local targets=()
                get_stat_field $filename $field_stats targets
                
                array_results+=( "${targets[$(($flowN_stats-1))]}" )
                if [ "`echo "${targets[$(($flowN_stats-1))]} == $expected_stats" | bc`" -eq 1 ] ; then
                    array_verifier=( "${array_verifier[@]}" "PASS" )
                else
                    array_verifier=( "${array_verifier[@]}" "FAIL" )
                fi                

            else

                local targets=()
                get_stat_field "$filename" "Flow Group" targets
                array_flow_group=( "${array_flow_group[@]}" "${targets[$(($flowN_stats-1))]}" )             

                local targets=()
                get_stat_field "$filename" "$field_stats" targets
                array_results=( "${array_results[@]}" "${targets[$(($flowN_stats-1))]}" )               
                
                if [ "`echo "${targets[$(($flowN_stats-1))]} >= $(echo "$expected_stats-$accur_stats" | bc)" | tr -d $'\r' | bc`" -eq 1 ] && [ "`echo "${targets[$(($flowN_stats-1))]} <= $(echo "$expected_stats+$accur_stats" | bc)" | tr -d $'\r' | bc`" -eq 1 ] ; then
                    array_verifier=( "${array_verifier[@]}" "PASS" )
                else
                    array_verifier=( "${array_verifier[@]}" "FAIL" )
                fi
            fi          
        fi
    done < $file_csv
    IFS=$OLDIFS

    # echo -e "${array_results[@]}"
    # echo -e "${array_verifier[@]}"

    # Append arrays as new columns:
    append_Results_csv $file_csv "Results" array_results > /dev/null 2>&1
    append_Results_csv $file_csv "Flow Group" array_flow_group
    append_Results_csv $file_csv "PASS/FAIL" array_verifier > /dev/null 2>&1
    append_Results_csv $file_csv "STATS" array_stats > /dev/null 2>&1
    
    # Filter columns to be displayed in the report file
    cp $file_csv cmds/tmp.csv
    mlr --csv reorder -f "STATS,Flow Number,Description,Field to verify,Accurancy,Expected,Results,PASS/FAIL" cmds/tmp.csv > $file_csv 
    
    rm -f cmds/tmp.csv

}


function analyze_results_pcap(){

    file_csv=$1

    sed -i '/^$/d' $file_csv
    dos2unix $file_csv > /dev/null 2>&1

    declare -a array_results=()
    declare -a array_verifier=()
    declare -a array_pcaps=()

    tmp_pcap=VERIFIER/Report/$config_type/${func}/${test_function}_tmp.pcap
    mkdir -p "${tmp_pcap%/*}" && touch $tmp_pcap    

    OLDIFS=$IFS
    IFS=","
    while read pcap_file descr_v frames_v filter_v expected_v
    do
        if [ -f $pcap_file ] && [ "$pcap_file" != pcap_file ] ; then
            array_pcaps=( "${array_pcaps[@]}" "$(basename ${pcap_file})" )
            if [ "$frames_v" == "*" ]; then
                array_results=( "${array_results[@]}" "$(tshark -n -q -r $pcap_file -z io,stat,0," $filter_v" | grep -P "\d+\.?\d*\s+<>\s+|Interval +\|" | tr -d " " | tr "|" "," | sed -E 's/<>/,/; s/(^,|,$)//g; s/Interval/Start,Stop/g' | sed "1 d" |  cut -d',' -f3 )" )
                
                if [ "${array_results[-1]}" == "$expected_v" ]; then
                    array_verifier=( "${array_verifier[@]}" "PASS" )
                else
                    array_verifier=( "${array_verifier[@]}" "FAIL" )
                fi
                
            else
                tshark -r $pcap_file -Y "$frames_v" -w $tmp_pcap
                array_results=( "${array_results[@]}" "$(tshark -n -q -r $tmp_pcap -z io,stat,0," $filter_v" | grep -P "\d+\.?\d*\s+<>\s+|Interval +\|" | tr -d " " | tr "|" "," | sed -E 's/<>/,/; s/(^,|,$)//g; s/Interval/Start,Stop/g' | sed "1 d" |  cut -d',' -f3 )" )
                
                if [ "${array_results[-1]}" == "$expected_v" ]; then
                    array_verifier=( "${array_verifier[@]}" "PASS" )
                else
                    array_verifier=( "${array_verifier[@]}" "FAIL" )
                fi
            fi
        fi
    done < $file_csv > /dev/null 2>&1 
    IFS=$OLDIFS  

    rm -f $tmp_pcap

    append_Results_csv $file_csv "Results" array_results > /dev/null 2>&1
    append_Results_csv $file_csv "PASS/FAIL" array_verifier > /dev/null 2>&1
    append_Results_csv $file_csv "PCAP" array_pcaps > /dev/null 2>&1
    
    cp $file_csv cmds/tmp.csv
    mlr --csv reorder -f "PCAP,Description,Frames to analyze,Filter,Expected,Results,PASS/FAIL" cmds/tmp.csv > $file_csv 
    
    rm -f cmds/tmp.csv

    #print_info "\nFor more information about the filters applied, check file $file_csv"
}


# CSV parser bash script: https://www.baeldung.com/linux/csv-parsing
