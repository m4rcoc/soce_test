

from scapy.all import *
import scapy.contrib.igmp
import sys
import os
import struct
import re
import random
import threading
import json
import time
from uuid import getnode
debug_path="/home/lab01/sw_develop/SOCE_TEST_24112021/soce_test/"
debug_path=""


def test_rstp_19_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

"""
test="test_rstp_9_1"
config_type="soce_cli"
func="rstp"

"""
test=sys.argv[1]
config_type=sys.argv[2]
func=sys.argv[3]

os.system("./bash_functions/vars_to_json.sh")
#filejson="/home/lab01/sw_develop/SOCE_TEST_24112021/soce_test/DUT_CONFIG_WEB/constants.json"
filejson=debug_path+"DUT_CONFIG_WEB/constants.json"
with open(filejson) as f:
    data = json.loads(f.read())
locals()[test+"_verifier"](test)
