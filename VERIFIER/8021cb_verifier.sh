#!/bin/bash



#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021CB.10 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021cb_10_1_verifier(){

mkdir -p REPORTS/${func}

fast_soce_cli "
frer get_per_port_statistics $port_0_config individual
frer get_per_port_per_stream_statistics $port_0_config individual 0
frer get_per_port_statistics $port_0_config sequence
frer get_per_port_per_stream_statistics $port_0_config sequence 0
frer get_per_port_statistics $port_1_config individual
frer get_per_port_per_stream_statistics $port_1_config individual 0
frer get_per_port_statistics $port_1_config sequence
frer get_per_port_per_stream_statistics $port_1_config sequence 0
" | tee -a REPORTS/${func}/${test_function}.out

export_results

}  

function test_8021cb_10_2_verifier(){

mkdir -p REPORTS/${func}

fast_soce_cli "
frer get_per_port_statistics $port_0_config individual
frer get_per_port_per_stream_statistics $port_0_config individual 0
frer get_per_port_statistics $port_0_config sequence
frer get_per_port_per_stream_statistics $port_0_config sequence 0
frer get_per_port_statistics $port_1_config individual
frer get_per_port_per_stream_statistics $port_1_config individual 0
frer get_per_port_statistics $port_1_config sequence
frer get_per_port_per_stream_statistics $port_1_config sequence 0
" | tee -a REPORTS/${func}/${test_function}.out

export_results

} 

function test_8021cb_10_3_verifier(){

mkdir -p REPORTS/${func}

fast_soce_cli "
frer get_per_port_statistics $port_0_config individual
frer get_per_port_per_stream_statistics $port_0_config individual 0
frer get_per_port_statistics $port_0_config sequence
frer get_per_port_per_stream_statistics $port_0_config sequence 0
frer get_per_port_statistics $port_1_config individual
frer get_per_port_per_stream_statistics $port_1_config individual 0
frer get_per_port_statistics $port_1_config sequence
frer get_per_port_per_stream_statistics $port_1_config sequence 0
" | tee -a REPORTS/${func}/${test_function}.out

export_results

} 

function test_8021cb_10_4_verifier(){

mkdir -p REPORTS/${func}

fast_soce_cli "
frer get_per_port_statistics $port_0_config individual
frer get_per_port_per_stream_statistics $port_0_config individual 0
frer get_per_port_statistics $port_0_config sequence
frer get_per_port_per_stream_statistics $port_0_config sequence 0
frer get_per_port_statistics $port_1_config individual
frer get_per_port_per_stream_statistics $port_1_config individual 0
frer get_per_port_statistics $port_1_config sequence
frer get_per_port_per_stream_statistics $port_1_config sequence 0
" | tee -a REPORTS/${func}/${test_function}.out

export_results

} 

function test_8021cb_10_5_verifier(){

mkdir -p REPORTS/${func}

fast_soce_cli "
frer get_per_port_statistics $port_0_config individual
frer get_per_port_per_stream_statistics $port_0_config individual 0
frer get_per_port_statistics $port_0_config sequence
frer get_per_port_per_stream_statistics $port_0_config sequence 0
frer get_per_port_statistics $port_1_config individual
frer get_per_port_per_stream_statistics $port_1_config individual 0
frer get_per_port_statistics $port_1_config sequence
frer get_per_port_per_stream_statistics $port_1_config sequence 0
" | tee -a REPORTS/${func}/${test_function}.out

export_results

}  
