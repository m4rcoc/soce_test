
estos son unos templates de Port/Flow Statistics generados por el IXIA.

Se han probado todos los campos disponibles (y que sean valores numéricos) en esos estadísticos

La prueba está descrita en el test verifier "throughput_limit_2_1":

function test_throughput_limit_2_1_verifier(){

# Import stats from Ixia VM
mkdir -p VERIFIER/Report/$config_type/${func}/${test_function}
import_ixia_stats "c:\\test\\reports\\${test_function}\\STEP3_${test_function}_Flow_Statistics_1G.txt" VERIFIER/Report/$config_type/${func}/${test_function}/STEP3_${test_function}_Flow_Statistics_1G.stats
import_ixia_stats "c:\\test\\reports\\${test_function}\\STEP3_${test_function}_Port_Statistics_1G.txt" VERIFIER/Report/$config_type/${func}/${test_function}/STEP3_${test_function}_Port_Statistics_1G.stats

fix_ixia_stats_file port_statistics_template.stats
fix_ixia_stats_file flow_statistics_template.stats


# Define conditions to verify:
FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

port_stats="port_statistics_template_advanced.stats"
flow_stats="flow_statistics_template.stats"

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected

$port_stats,1,TBD,Frames Tx.,0.5,111.299
$port_stats,1,TBD,Valid Frames Rx.,0.5,221.722
$port_stats,1,TBD,Frames Tx. Rate,0.5,0
$port_stats,1,TBD,Valid Frames Rx. Rate,0.5,0
$port_stats,1,TBD,Data Integrity Frames Rx.,0.5,0
$port_stats,1,TBD,Data Integrity Errors,0.5,0
$port_stats,1,TBD,Bytes Tx.,0.5,0
$port_stats,1,TBD,Bytes Rx.,0.5,0
$port_stats,1,TBD,Bits Sent,0.5,0
$port_stats,1,TBD,Bits Received,0.5,0
$port_stats,1,TBD,Bytes Tx. Rate,0.5,0
$port_stats,1,TBD,Tx. Rate (bps),0.5,0
$port_stats,1,TBD,Tx. Rate (Kbps),0.5,0
$port_stats,1,TBD,Tx. Rate (Mbps),0.5,0
$port_stats,1,TBD,Bytes Rx. Rate,0.5,0
$port_stats,1,TBD,Rx. Rate (bps),0.5,0
$port_stats,1,TBD,Rx. Rate (Kbps),0.5,0
$port_stats,1,TBD,Rx. Rate (Mbps),0.5,0
$port_stats,1,TBD,Scheduled Frames Tx.,0.5,0
$port_stats,1,TBD,Scheduled Frames Tx. Rate,0.5,0
$port_stats,1,TBD,Control Frames Tx,0.5,0
$port_stats,1,TBD,Control Frames Rx,0.5,0
$port_stats,1,TBD,Ethernet OAM Information PDUs Sent,0.5,0
$port_stats,1,TBD,Ethernet OAM Information PDUs Received,0.5,0
$port_stats,1,TBD,Ethernet OAM Event Notification PDUs Received,0.5,0
$port_stats,1,TBD,Ethernet OAM Loopback Control PDUs Received,0.5,0
$port_stats,1,TBD,Ethernet OAM Organisation PDUs Received,0.5,0
$port_stats,1,TBD,Ethernet OAM Variable Request PDUs Received,0.5,0
$port_stats,1,TBD,Ethernet OAM Variable Response Received,0.5,0
$port_stats,1,TBD,Ethernet OAM Unsupported PDUs Received,0.5,0
$port_stats,1,TBD,Rx Pause Priority Group 0 Frames,0.5,0
$port_stats,1,TBD,Rx Pause Priority Group 1 Frames,0.5,0
$port_stats,1,TBD,Rx Pause Priority Group 2 Frames,0.5,0
$port_stats,1,TBD,Rx Pause Priority Group 3 Frames,0.5,0
$port_stats,1,TBD,Rx Pause Priority Group 4 Frames,0.5,0
$port_stats,1,TBD,Rx Pause Priority Group 5 Frames,0.5,0
$port_stats,1,TBD,Rx Pause Priority Group 6 Frames,0.5,0
$port_stats,1,TBD,Rx Pause Priority Group 7 Frames,0.5,0
$port_stats,1,TBD,Misdirected Packet Count,0.5,0
$port_stats,1,TBD,CRC Errors,0.5,4040.4040

$port_stats,2,TBD,Frames Tx.,0.5,0
$port_stats,2,TBD,Valid Frames Rx.,0.5,0
$port_stats,2,TBD,Frames Tx. Rate,0.5,0
$port_stats,2,TBD,Valid Frames Rx. Rate,0.5,0
$port_stats,2,TBD,Data Integrity Frames Rx.,0.5,0
$port_stats,2,TBD,Data Integrity Errors,0.5,0
$port_stats,2,TBD,Bytes Tx.,0.5,0
$port_stats,2,TBD,Bytes Rx.,0.5,0
$port_stats,2,TBD,Bits Sent,0.5,0
$port_stats,2,TBD,Bits Received,0.5,0
$port_stats,2,TBD,Bytes Tx. Rate,0.5,0
$port_stats,2,TBD,Tx. Rate (bps),0.5,0
$port_stats,2,TBD,Tx. Rate (Kbps),0.5,0
$port_stats,2,TBD,Tx. Rate (Mbps),0.5,0
$port_stats,2,TBD,Bytes Rx. Rate,0.5,0
$port_stats,2,TBD,Rx. Rate (bps),0.5,0
$port_stats,2,TBD,Rx. Rate (Kbps),0.5,0
$port_stats,2,TBD,Rx. Rate (Mbps),0.5,0
$port_stats,2,TBD,Scheduled Frames Tx.,0.5,0
$port_stats,2,TBD,Scheduled Frames Tx. Rate,0.5,0
$port_stats,2,TBD,Control Frames Tx,0.5,0
$port_stats,2,TBD,Control Frames Rx,0.5,0
$port_stats,2,TBD,Ethernet OAM Information PDUs Sent,0.5,0
$port_stats,2,TBD,Ethernet OAM Information PDUs Received,0.5,0
$port_stats,2,TBD,Ethernet OAM Event Notification PDUs Received,0.5,0
$port_stats,2,TBD,Ethernet OAM Loopback Control PDUs Received,0.5,0
$port_stats,2,TBD,Ethernet OAM Organisation PDUs Received,0.5,0
$port_stats,2,TBD,Ethernet OAM Variable Request PDUs Received,0.5,0
$port_stats,2,TBD,Ethernet OAM Variable Response Received,0.5,0
$port_stats,2,TBD,Ethernet OAM Unsupported PDUs Received,0.5,0
$port_stats,2,TBD,Rx Pause Priority Group 0 Frames,0.5,0
$port_stats,2,TBD,Rx Pause Priority Group 1 Frames,0.5,0
$port_stats,2,TBD,Rx Pause Priority Group 2 Frames,0.5,0
$port_stats,2,TBD,Rx Pause Priority Group 3 Frames,0.5,0
$port_stats,2,TBD,Rx Pause Priority Group 4 Frames,0.5,0
$port_stats,2,TBD,Rx Pause Priority Group 5 Frames,0.5,0
$port_stats,2,TBD,Rx Pause Priority Group 6 Frames,0.5,0
$port_stats,2,TBD,Rx Pause Priority Group 7 Frames,0.5,0
$port_stats,2,TBD,Misdirected Packet Count,0.5,0
$port_stats,2,TBD,CRC Errors,0.5,0


$flow_stats,1,TBD,Tx Frames,0.5,0
$flow_stats,1,TBD,Rx Frames,0.5,0
$flow_stats,1,TBD,Frames Delta,0.5,0
$flow_stats,1,TBD,Loss %,0.5,0
$flow_stats,1,TBD,Tx Frame Rate,0.5,0
$flow_stats,1,TBD,Rx Frame Rate,0.5,0
$flow_stats,1,TBD,Tx L1 Rate (bps),0.5,0
$flow_stats,1,TBD,Rx L1 Rate (bps),0.5,0
$flow_stats,1,TBD,Rx Bytes,0.5,0
$flow_stats,1,TBD,Tx Rate (Bps),0.5,0
$flow_stats,1,TBD,Rx Rate (Bps),0.5,0
$flow_stats,1,TBD,Tx Rate (bps),0.5,0
$flow_stats,1,TBD,Rx Rate (bps),0.5,0
$flow_stats,1,TBD,Tx Rate (Kbps),0.5,0
$flow_stats,1,TBD,Rx Rate (Kbps),0.5,0
$flow_stats,1,TBD,Tx Rate (Mbps),0.5,0
$flow_stats,1,TBD,Rx Rate (Mbps),0.5,0
$flow_stats,1,TBD,Store-Forward Avg Latency (ns),0.5,0
$flow_stats,1,TBD,Store-Forward Min Latency (ns),0.5,0
$flow_stats,1,TBD,Store-Forward Max Latency (ns),0.5,0

$flow_stats,1,TBD,Dead Flow,0.5,0

$flow_stats,7,TBD,Tx Frames,0.5,0
$flow_stats,7,TBD,Rx Frames,0.5,0
$flow_stats,7,TBD,Frames Delta,0.5,0
$flow_stats,7,TBD,Loss %,0.5,0
$flow_stats,7,TBD,Tx Frame Rate,0.5,0
$flow_stats,7,TBD,Rx Frame Rate,0.5,0
$flow_stats,7,TBD,Tx L1 Rate (bps),0.5,0
$flow_stats,7,TBD,Rx L1 Rate (bps),0.5,0
$flow_stats,7,TBD,Rx Bytes,0.5,0
$flow_stats,7,TBD,Tx Rate (Bps),0.5,0
$flow_stats,7,TBD,Rx Rate (Bps),0.5,0
$flow_stats,7,TBD,Tx Rate (bps),0.5,0
$flow_stats,7,TBD,Rx Rate (bps),0.5,0
$flow_stats,7,TBD,Tx Rate (Kbps),0.5,0
$flow_stats,7,TBD,Rx Rate (Kbps),0.5,0
$flow_stats,7,TBD,Tx Rate (Mbps),0.5,0
$flow_stats,7,TBD,Rx Rate (Mbps),0.5,0
$flow_stats,7,TBD,Store-Forward Avg Latency (ns),0.5,0
$flow_stats,7,TBD,Store-Forward Min Latency (ns),0.5,0
$flow_stats,7,TBD,Store-Forward Max Latency (ns),0.5,0

$flow_stats,7,TBD,Dead Flow,0.5,0
EOF


# Processing stats
analyze_results_stats $FILE_CSV

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "STATS,Flow Number,Description,Field to verify,Accurancy,Expected,Results,PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

# print_csv $FILE_CSV

# export_results

}  
