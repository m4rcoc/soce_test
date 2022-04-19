#!/bin/bash

# Usage to execute tests: 
# . ./automated_tests.sh && <functionality>

function 8021qci(){

./soce_test.sh -f 8021qci -t 3 -p 1 -c soce_cli
./soce_test.sh -f 8021qci -t 4 -p 1 -c soce_cli
./soce_test.sh -f 8021qci -t 5 -p 1 -c soce_cli
./soce_test.sh -f 8021qci -t 6 -p 1 -c soce_cli
./soce_test.sh -f 8021qci -t 7 -p 1 -c soce_cli
}

function multiple_stream_identification(){

# OK 
./soce_test.sh -f multiple_stream_identification -t 1 -p 1 -c soce_cli
./soce_test.sh -f multiple_stream_identification -t 2 -p 1 -c soce_cli
./soce_test.sh -f multiple_stream_identification -t 3 -p 1 -c soce_cli
./soce_test.sh -f multiple_stream_identification -t 4 -p 1 -c soce_cli

}

function throughput_limit(){

./soce_test.sh -f throughput_limit -t 1 -p 1 -c soce_cli
./soce_test.sh -f throughput_limit -t 1 -p 2 -c soce_cli
./soce_test.sh -f throughput_limit -t 1 -p 3 -c soce_cli
./soce_test.sh -f throughput_limit -t 1 -p 4 -c soce_cli

# ./soce_test.sh -f throughput_limit -t 2 -p 1 -c soce_cli
# ./soce_test.sh -f throughput_limit -t 2 -p 2 -c soce_cli
# ./soce_test.sh -f throughput_limit -t 2 -p 3 -c soce_cli
# ./soce_test.sh -f throughput_limit -t 2 -p 4 -c soce_cli

}

function netconf(){

# OK (OJO -> test 2 con setup IXIA)
./soce_test.sh -f netconf -t 1 -p 1 -c netconf
#./soce_test.sh -f netconf -t 2 -p 1 -c netconf
./soce_test.sh -f netconf -t 3 -p 1 -c netconf
./soce_test.sh -f netconf -t 4 -p 1 -c netconf

}

function 8021qav(){

./soce_test.sh -f 8021qav -t 1 -p 1 -c soce_cli
./soce_test.sh -f 8021qav -t 1 -p 2 -c soce_cli

./soce_test.sh -f 8021qav -t 2 -p 1 -c soce_cli

}

function 8021qav_tsn_pcie(){

./soce_test.sh -f 8021qav -t 1 -p 1 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qav -t 1 -p 2 -c soce_cli -s tsn_pcie

./soce_test.sh -f 8021qav -t 2 -p 1 -c soce_cli -s tsn_pcie

}

function 8021qbv(){

# # OK
# ./soce_test.sh -f 8021qbv -t 1 -p 1 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 2 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 3 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 4 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 5 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 6 -c soce_cli -s start

# test 2 -> manual

# test 3 -> manual

# OK
./soce_test.sh -f 8021qbv -t 4 -p 1 -c soce_cli
./soce_test.sh -f 8021qbv -t 4 -p 2 -c soce_cli
./soce_test.sh -f 8021qbv -t 4 -p 3 -c soce_cli
./soce_test.sh -f 8021qbv -t 4 -p 4 -c soce_cli
./soce_test.sh -f 8021qbv -t 4 -p 5 -c soce_cli
./soce_test.sh -f 8021qbv -t 4 -p 6 -c soce_cli
./soce_test.sh -f 8021qbv -t 4 -p 7 -c soce_cli
./soce_test.sh -f 8021qbv -t 4 -p 8 -c soce_cli


# OK
./soce_test.sh -f 8021qbv -t 5 -p 1 -c soce_cli
./soce_test.sh -f 8021qbv -t 5 -p 2 -c soce_cli
./soce_test.sh -f 8021qbv -t 5 -p 3 -c soce_cli

# OK
./soce_test.sh -f 8021qbv -t 6 -p 1 -c soce_cli
./soce_test.sh -f 8021qbv -t 6 -p 2 -c soce_cli
./soce_test.sh -f 8021qbv -t 6 -p 3 -c soce_cli
./soce_test.sh -f 8021qbv -t 6 -p 4 -c soce_cli
./soce_test.sh -f 8021qbv -t 6 -p 5 -c soce_cli
./soce_test.sh -f 8021qbv -t 6 -p 6 -c soce_cli
./soce_test.sh -f 8021qbv -t 6 -p 7 -c soce_cli
./soce_test.sh -f 8021qbv -t 6 -p 8 -c soce_cli
./soce_test.sh -f 8021qbv -t 6 -p 9 -c soce_cli

# OK
./soce_test.sh -f 8021qbv -t 7 -p 1 -c soce_cli

# OK
./soce_test.sh -f 8021qbv -t 8 -p 1 -c soce_cli

# test 9 -> manual
# test 10 -> manual
# test 11 -> manual
# test 12 -> no definido
# test 13 -> manual


}

function 8021qbv_tsn_pcie(){

# # OK
# ./soce_test.sh -f 8021qbv -t 1 -p 1 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 2 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 3 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 4 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 5 -c soce_cli -s start
# ./soce_test.sh -f 8021qbv -t 1 -p 6 -c soce_cli -s start

# test 2 -> manual

# test 3 -> manual

# OK
./soce_test.sh -f 8021qbv -t 4 -p 1 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 4 -p 2 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 4 -p 3 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 4 -p 4 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 4 -p 5 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 4 -p 6 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 4 -p 7 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 4 -p 8 -c soce_cli -s tsn_pcie


# OK
./soce_test.sh -f 8021qbv -t 5 -p 1 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 5 -p 2 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 5 -p 3 -c soce_cli -s tsn_pcie

# OK
./soce_test.sh -f 8021qbv -t 6 -p 1 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 6 -p 2 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 6 -p 3 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 6 -p 4 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 6 -p 5 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 6 -p 6 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 6 -p 7 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 6 -p 8 -c soce_cli -s tsn_pcie
./soce_test.sh -f 8021qbv -t 6 -p 9 -c soce_cli -s tsn_pcie

# OK
./soce_test.sh -f 8021qbv -t 7 -p 1 -c soce_cli -s tsn_pcie

# OK
./soce_test.sh -f 8021qbv -t 8 -p 1 -c soce_cli -s tsn_pcie

# test 9 -> manual

# test 10 -> manual

}

function 8021qbv_2(){


./soce_test.sh -f 8021qbv -t 2 -p 1 -c soce_cli -d restore
./soce_test.sh -f 8021qbv -t 2 -p 1 -c soce_cli -d config
./soce_test.sh -f 8021qbv -t 2 -p 1 -c soce_cli -s start -d traffic
./soce_test.sh -f 8021qbv -t 2 -p 2 -c soce_cli -d config
./soce_test.sh -f 8021qbv -t 2 -p 2 -c soce_cli -d verifier
./soce_test.sh -f 8021qbv -t 2 -p 3 -c soce_cli -d config
./soce_test.sh -f 8021qbv -t 2 -p 1 -c soce_cli -s clear -d traffic
./soce_test.sh -f 8021qbv -t 2 -p 3 -c soce_cli -d verifier
./soce_test.sh -f 8021qbv -t 2 -p 3 -c soce_cli -d restore

}

function switching_portmask(){

./soce_test.sh -f switching_portmask -t 1 -p 1 -c soce_cli
./soce_test.sh -f switching_portmask -t 1 -p 2 -c soce_cli
./soce_test.sh -f switching_portmask -t 1 -p 3 -c soce_cli

}

function edsa(){

./soce_test.sh -f edsa -t 1 -p 1 -c soce_cli

./soce_test.sh -f edsa -t 2 -p 1 -c soce_cli

./soce_test.sh -f edsa -t 3 -p 1 -c soce_cli

./soce_test.sh -f edsa -t 4 -p 1 -c soce_cli
}

function igmp(){

./soce_test.sh -f igmp -t 2 -p 1 -c soce_cli
./soce_test.sh -f igmp -t 2 -p 2 -c soce_cli

./soce_test.sh -f igmp -t 3 -p 1 -c soce_cli
./soce_test.sh -f igmp -t 3 -p 2 -c soce_cli

./soce_test.sh -f igmp -t 4 -p 1 -c soce_cli

./soce_test.sh -f igmp -t 5 -p 1 -c soce_cli
./soce_test.sh -f igmp -t 5 -p 2 -c soce_cli
./soce_test.sh -f igmp -t 5 -p 3 -c soce_cli
./soce_test.sh -f igmp -t 5 -p 4 -c soce_cli
./soce_test.sh -f igmp -t 5 -p 5 -c soce_cli
./soce_test.sh -f igmp -t 5 -p 6 -c soce_cli
}

function hsr(){

./soce_test.sh -f hsr -t 1 -p 1 -c soce_cli
./soce_test.sh -f hsr -t 1 -p 2 -c soce_cli

./soce_test.sh -f hsr -t 2 -p 1 -c soce_cli

./soce_test.sh -f hsr -t 3 -p 1 -c soce_cli
./soce_test.sh -f hsr -t 3 -p 2 -c soce_cli
./soce_test.sh -f hsr -t 3 -p 3 -c soce_cli
./soce_test.sh -f hsr -t 3 -p 4 -c soce_cli

./soce_test.sh -f hsr -t 4 -p 1 -c soce_cli
./soce_test.sh -f hsr -t 4 -p 2 -c soce_cli
./soce_test.sh -f hsr -t 4 -p 3 -c soce_cli
./soce_test.sh -f hsr -t 4 -p 4 -c soce_cli

# ./soce_test.sh -f hsr -t 5 -p 1 -c soce_cli
# ./soce_test.sh -f hsr -t 5 -p 2 -c soce_cli
# ./soce_test.sh -f hsr -t 5 -p 3 -c soce_cli
# ./soce_test.sh -f hsr -t 5 -p 4 -c soce_cli

./soce_test.sh -f hsr -t 9 -p 1 -c soce_cli

./soce_test.sh -f hsr -t 10 -p 1 -c soce_cli

./soce_test.sh -f hsr -t 11 -p 1 -c soce_cli

./soce_test.sh -f hsr -t 12 -p 1 -c soce_cli

./soce_test.sh -f hsr -t 13 -p 1 -c soce_cli

./soce_test.sh -f hsr -t 14 -p 1 -c soce_cli

./soce_test.sh -f hsr -t 15 -p 1 -c soce_cli

}

function prp(){
    
./soce_test.sh -f prp -t 1 -p 1 -c soce_cli
./soce_test.sh -f prp -t 1 -p 2 -c soce_cli

./soce_test.sh -f prp -t 2 -p 1 -c soce_cli

./soce_test.sh -f prp -t 3 -p 1 -c soce_cli
./soce_test.sh -f prp -t 3 -p 2 -c soce_cli
./soce_test.sh -f prp -t 3 -p 3 -c soce_cli
./soce_test.sh -f prp -t 3 -p 4 -c soce_cli

./soce_test.sh -f prp -t 4 -p 1 -c soce_cli
./soce_test.sh -f prp -t 4 -p 2 -c soce_cli
./soce_test.sh -f prp -t 4 -p 3 -c soce_cli
./soce_test.sh -f prp -t 4 -p 4 -c soce_cli

./soce_test.sh -f prp -t 5 -p 1 -c soce_cli
./soce_test.sh -f prp -t 5 -p 2 -c soce_cli
./soce_test.sh -f prp -t 5 -p 3 -c soce_cli
./soce_test.sh -f prp -t 5 -p 4 -c soce_cli

}

function prp_pcie_lp(){
    
./soce_test.sh -f prp -t 1 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 1 -p 2 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 2 -p 1 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 3 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 3 -p 2 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 3 -p 3 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 3 -p 4 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 4 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 4 -p 2 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 4 -p 3 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 4 -p 4 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 5 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 5 -p 2 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 5 -p 3 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 5 -p 4 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 7 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 7 -p 2 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 7 -p 3 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 7 -p 4 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 9 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 9 -p 2 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 10 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 10 -p 2 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 11 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 11 -p 2 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 13 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 13 -p 2 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 13 -p 3 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 14 -p 1 -c soce_cli -s pcie_lp

./soce_test.sh -f prp -t 15 -p 1 -c soce_cli -s pcie_lp
./soce_test.sh -f prp -t 15 -p 2 -c soce_cli -s pcie_lp

}

function ntp(){

./soce_test.sh -f ntp -t 1 -p 1 -c soce_cli

./soce_test.sh -f ntp -t 2 -p 1 -c soce_cli
./soce_test.sh -f ntp -t 2 -p 2 -c soce_cli
./soce_test.sh -f ntp -t 2 -p 3 -c soce_cli
./soce_test.sh -f ntp -t 2 -p 4 -c soce_cli
./soce_test.sh -f ntp -t 2 -p 5 -c soce_cli
./soce_test.sh -f ntp -t 2 -p 6 -c soce_cli
./soce_test.sh -f ntp -t 2 -p 7 -c soce_cli

./soce_test.sh -f ntp -t 5 -p 1 -c soce_cli

./soce_test.sh -f ntp -t 6 -p 1 -c soce_cli
./soce_test.sh -f ntp -t 6 -p 2 -c soce_cli

}


function port_mirroring(){

./soce_test.sh -f port_mirroring -t 1 -p 1 -c soce_cli
./soce_test.sh -f port_mirroring -t 1 -p 2 -c soce_cli
./soce_test.sh -f port_mirroring -t 1 -p 1 -c soce_web
./soce_test.sh -f port_mirroring -t 1 -p 2 -c soce_web




./soce_test.sh -f port_mirroring -t 2 -p 1 -c soce_web
./soce_test.sh -f port_mirroring -t 2 -p 2 -c soce_web


./soce_test.sh -f port_mirroring -t 2 -p 1 -c soce_cli
./soce_test.sh -f port_mirroring -t 2 -p 2 -c soce_cli
}


function vlan(){
  
# ./soce_test.sh -f vlan -t 1 -p 1 -c soce_web
# ./soce_test.sh -f vlan -t 1 -p 2 -c soce_web
# ./soce_test.sh -f vlan -t 1 -p 3 -c soce_web
# ./soce_test.sh -f vlan -t 1 -p 4 -c soce_web
# ./soce_test.sh -f vlan -t 2 -p 1 -c soce_web
# ./soce_test.sh -f vlan -t 2 -p 2 -c soce_web
# ./soce_test.sh -f vlan -t 3 -p 1 -c soce_web
# ./soce_test.sh -f vlan -t 4 -p 1 -c soce_web
# ./soce_test.sh -f vlan -t 4 -p 2 -c soce_web
# ./soce_test.sh -f vlan -t 5 -p 1 -c soce_web
# ./soce_test.sh -f vlan -t 5 -p 2 -c soce_web
# ./soce_test.sh -f vlan -t 5 -p 3 -c soce_web
# ./soce_test.sh -f vlan -t 5 -p 4 -c soce_web
# ./soce_test.sh -f vlan -t 6 -p 1 -c soce_web
# ./soce_test.sh -f vlan -t 6 -p 2 -c soce_web
# ./soce_test.sh -f vlan -t 6 -p 3 -c soce_web
# ./soce_test.sh -f vlan -t 6 -p 4 -c soce_web
# ./soce_test.sh -f vlan -t 7 -p 1 -c soce_web
# ./soce_test.sh -f vlan -t 7 -p 2 -c soce_web
# ./soce_test.sh -f vlan -t 7 -p 3 -c soce_web
# ./soce_test.sh -f vlan -t 7 -p 4 -c soce_web
# ./soce_test.sh -f vlan -t 7 -p 5 -c soce_web
# ./soce_test.sh -f vlan -t 7 -p 6 -c soce_web
# ./soce_test.sh -f vlan -t 7 -p 7 -c soce_web
# ./soce_test.sh -f vlan -t 7 -p 8 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 1 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 2 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 3 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 4 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 5 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 6 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 7 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 8 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 9 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 10 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 11 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 12 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 13 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 14 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 15 -c soce_web
# ./soce_test.sh -f vlan -t 8 -p 16 -c soce_web

./soce_test.sh -f vlan -t 1 -p 1 -c soce_cli
./soce_test.sh -f vlan -t 1 -p 2 -c soce_cli
./soce_test.sh -f vlan -t 1 -p 3 -c soce_cli
./soce_test.sh -f vlan -t 1 -p 4 -c soce_cli
./soce_test.sh -f vlan -t 2 -p 1 -c soce_cli
./soce_test.sh -f vlan -t 2 -p 2 -c soce_cli
./soce_test.sh -f vlan -t 3 -p 1 -c soce_cli
./soce_test.sh -f vlan -t 4 -p 1 -c soce_cli
./soce_test.sh -f vlan -t 4 -p 2 -c soce_cli
./soce_test.sh -f vlan -t 5 -p 1 -c soce_cli
./soce_test.sh -f vlan -t 5 -p 2 -c soce_cli
./soce_test.sh -f vlan -t 5 -p 3 -c soce_cli
./soce_test.sh -f vlan -t 5 -p 4 -c soce_cli
./soce_test.sh -f vlan -t 6 -p 1 -c soce_cli
./soce_test.sh -f vlan -t 6 -p 2 -c soce_cli
./soce_test.sh -f vlan -t 6 -p 3 -c soce_cli
./soce_test.sh -f vlan -t 6 -p 4 -c soce_cli
./soce_test.sh -f vlan -t 7 -p 1 -c soce_cli
./soce_test.sh -f vlan -t 7 -p 2 -c soce_cli
./soce_test.sh -f vlan -t 7 -p 3 -c soce_cli
./soce_test.sh -f vlan -t 7 -p 4 -c soce_cli
./soce_test.sh -f vlan -t 7 -p 5 -c soce_cli
./soce_test.sh -f vlan -t 7 -p 6 -c soce_cli
./soce_test.sh -f vlan -t 7 -p 7 -c soce_cli
./soce_test.sh -f vlan -t 7 -p 8 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 1 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 2 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 3 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 4 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 5 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 6 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 7 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 8 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 9 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 10 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 11 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 12 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 13 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 14 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 15 -c soce_cli
./soce_test.sh -f vlan -t 8 -p 16 -c soce_cli
}

function web(){

./soce_test.sh -f web_8x8 -t 1 -p 1 -c soce_web
./soce_test.sh -f web_8x8 -t 2 -p 1 -c soce_web
./soce_test.sh -f web_8x8 -t 2 -p 2 -c soce_web
./soce_test.sh -f web_8x8 -t 3 -p 1 -c soce_web 
./soce_test.sh -f web_8x8 -t 5 -p 1 -c soce_web
./soce_test.sh -f web_8x8 -t 6 -p 1 -c soce_web
./soce_test.sh -f web_8x8 -t 7 -p 1 -c soce_web 
./soce_test.sh -f web_8x8 -t 7 -p 2 -c soce_web
./soce_test.sh -f web_8x8 -t 8 -p 1 -c soce_web 
./soce_test.sh -f web_8x8 -t 9 -p 1 -c soce_web
./soce_test.sh -f web_8x8 -t 10 -p 1 -c soce_web
}