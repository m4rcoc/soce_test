

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
debug_path="/home/lab01/sw_develop/Soce_test_14012022/"
debug_path=""
def test_rstp_1_1_verifier(test):


    f=open("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap")
    pass_IF1=1
    count=0
    for i in array_pkts_IF1:
        if (i[Ether].src=="aa:aa:aa:aa:aa:aa" or i[Ether].src =="AA:AA:AA:AA:AA:AA") and (i[Ether].dst =="00:bb:bb:bb:bb:bb" or i[Ether].dst =="00:BB:BB:BB:BB:BB"):
            count=count+1
        if i[Ether].src =="00:bb:bb:bb:bb:bb" or i[Ether].src =="00:BB:BB:BB:BB:BB" or i[Ether].src =="cc:cc:cc:cc:cc:cc" or i[Ether].src =="CC:CC:CC:CC:CC:CC":
            pass_IF1=0
    if count==1000 and pass_IF1==1:
        pass_IF1=1
    else:
        pass_IF1=0

    array_pkts_IF2=rdpcap("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap")
    pass_IF2=1
    count=0
    for i in array_pkts_IF2:
        if (i[Ether].src=="00:bb:bb:bb:bb:bb" or i[Ether].src =="00:BB:BB:BB:BB:BB") and (i[Ether].dst =="cc:cc:cc:cc:cc:cc" or i[Ether].dst =="CC:CC:CC:CC:CC:CC"):
            count=count+1
        if i[Ether].src =="aa:aa:aa:aa:aa:aa" or i[Ether].src =="AA:AA:AA:AA:AA:AA" or i[Ether].src =="cc:cc:cc:cc:cc:cc" or i[Ether].src =="CC:CC:CC:CC:CC:CC":
            pass_IF2=0
    if count==1000 and pass_IF2==1:
        pass_IF2=1
    else:
        pass_IF2=0


    array_pkts_IF3=rdpcap("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap")

    pass_IF3=1
    count=0
    for i in array_pkts_IF3:
        if (i[Ether].src=="cc:cc:cc:cc:cc:cc" or i[Ether].src =="CC:CC:CC:CC:CC:CC") and (i[Ether].dst =="aa:aa:aa:aa:aa:aa" or i[Ether].dst =="AA:AA:AA:AA:AA:AA"):
            count=count+1
        if i[Ether].src =="00:bb:bb:bb:bb:bb" or i[Ether].src =="00:BB:BB:BB:BB:BB" or i[Ether].src =="aa:aa:aa:aa:aa:aa" or i[Ether].src =="AA:AA:AA:AA:AA:AA":
            pass_IF3=0
    if count==1000 and pass_IF3==1:
        pass_IF3=1
    else:
        pass_IF3=0

    q=open("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("mac_address_table get_port_entries "+data["port_0_name"])
    fin=out.find("mac_address_table get_port_entries "+data["port_1_name"])
    out_aux=out[inicio:fin]
    esta=out.find("AA:AA:AA:AA:AA:AA")
    esta2=out.find("aa:aa:aa:aa:aa:aa")
    if esta!=-1 and esta2!=-1:
        pass_MAC1=0
    else:
        pass_MAC1=1    
    

    inicio=out.find("mac_address_table get_port_entries "+data["port_1_name"])
    fin=out.find("mac_address_table get_port_entries "+data["port_2_name"])
    out_aux=out[inicio:fin]
    esta=out.find("00:BB:BB:BB:BB:BB") 
    esta2=out.find("00:bb:bb:bb:bb:bb")
    if esta!=-1 and esta2!=-1:
        pass_MAC2=0
    else:
        pass_MAC2=1


    
    inicio=out.find("mac_address_table get_port_entries "+data["port_2_name"])
    fin=out.find("mac_address_table get_port_entries "+data["port_3_name"])
    out_aux=out[inicio:fin]
    esta=out.find("CC:CC:CC:CC:CC:CC")
    esta2=out.find("cc:cc:cc:cc:cc:cc")
    if esta!=-1 and esta2!=-1:
        pass_MAC3=0
    else:
        pass_MAC3=1    
    
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_IF1!=0 and pass_IF2!=0 and pass_IF3!=0 and pass_MAC1!=0 and pass_MAC2!=0 and pass_MAC3!=0:
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail"+current_time+"\n")
        if pass_IF1==0:
            f.write("Packet from IF2 and/or IF3 has been recorded on IF1 when it should not\n")
        if pass_IF2==0:
            f.write("Packet from IF1 and/or IF3 has been recorded on IF2 when it should not\n")
        if pass_IF3==0:
            f.write("Packet from IF1 and/or IF2 has been recorded on IF3 when it should not\n")
        if pass_MAC1==0:
            f.write("MAC AA:AA:AA:AA:AA:AA found on MAC table when it should not be")
        if pass_MAC2==0:
            f.write("MAC 00:BB:BB:BB:BB:BB found on MAC table when it should not be")
        if pass_MAC3==0:
            f.write("MAC CC:CC:CC:CC:CC:CC found on MAC table when it should not be")       
                 
                 
    f.close()
    return

def test_rstp_2_1_verifier(test):


    f=open("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap")
    pass_IF1=1
    count=0
    for i in array_pkts_IF1:
        if (i[Ether].src=="aa:aa:aa:aa:aa:aa" or i[Ether].src =="AA:AA:AA:AA:AA:AA") and (i[Ether].dst =="00:bb:bb:bb:bb:bb" or i[Ether].dst =="00:BB:BB:BB:BB:BB"):
            count=count+1
        if i[Ether].src =="00:bb:bb:bb:bb:bb" or i[Ether].src =="00:BB:BB:BB:BB:BB" or i[Ether].src =="cc:cc:cc:cc:cc:cc" or i[Ether].src =="CC:CC:CC:CC:CC:CC":
            pass_IF1=0
    if count==1000 and pass_IF1==1:
        pass_IF1=1
    else:
        pass_IF1=0

    array_pkts_IF2=rdpcap("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap")
    pass_IF2=1
    count=0
    for i in array_pkts_IF2:
        if (i[Ether].src=="00:bb:bb:bb:bb:bb" or i[Ether].src =="00:BB:BB:BB:BB:BB") and (i[Ether].dst =="cc:cc:cc:cc:cc:cc" or i[Ether].dst =="CC:CC:CC:CC:CC:CC"):
            count=count+1
        if i[Ether].src =="aa:aa:aa:aa:aa:aa" or i[Ether].src =="AA:AA:AA:AA:AA:AA" or i[Ether].src =="cc:cc:cc:cc:cc:cc" or i[Ether].src =="CC:CC:CC:CC:CC:CC":
            pass_IF2=0
    if count==1000 and pass_IF2==1:
        pass_IF2=1
    else:
        pass_IF2=0


    array_pkts_IF3=rdpcap("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap")

    pass_IF3=1
    count=0
    for i in array_pkts_IF3:
        if (i[Ether].src=="cc:cc:cc:cc:cc:cc" or i[Ether].src =="CC:CC:CC:CC:CC:CC") and (i[Ether].dst =="aa:aa:aa:aa:aa:aa" or i[Ether].dst =="AA:AA:AA:AA:AA:AA"):
            count=count+1
        if i[Ether].src =="00:bb:bb:bb:bb:bb" or i[Ether].src =="00:BB:BB:BB:BB:BB" or i[Ether].src =="aa:aa:aa:aa:aa:aa" or i[Ether].src =="AA:AA:AA:AA:AA:AA":
            pass_IF3=0
    if count==1000 and pass_IF3==1:
        pass_IF3=1
    else:
        pass_IF3=0

    q=open("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("mac_address_table get_port_entries "+data["port_0_name"])
    fin=out.find("mac_address_table get_port_entries "+data["port_1_name"])
    out_aux=out[inicio:fin]
    esta=out.find("AA:AA:AA:AA:AA:AA")
    esta2=out.find("aa:aa:aa:aa:aa:aa")
    if esta!=-1 or esta2!=-1:
        pass_MAC1=1
    else:
        pass_MAC1=0    
    

    inicio=out.find("mac_address_table get_port_entries "+data["port_1_name"])
    fin=out.find("mac_address_table get_port_entries "+data["port_2_name"])
    out_aux=out[inicio:fin]
    esta=out.find("00:BB:BB:BB:BB:BB") 
    esta2=out.find("00:bb:bb:bb:bb:bb")
    if esta!=-1 or esta2!=-1:
        pass_MAC2=1
    else:
        pass_MAC2=0


    
    inicio=out.find("mac_address_table get_port_entries "+data["port_2_name"])
    fin=out.find("mac_address_table get_port_entries "+data["port_3_name"])
    out_aux=out[inicio:fin]
    esta=out.find("CC:CC:CC:CC:CC:CC")
    esta2=out.find("cc:cc:cc:cc:cc:cc")
    if esta!=-1 or esta2!=-1:
        pass_MAC3=1
    else:
        pass_MAC3=0     
    
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_IF1!=0 and pass_IF2!=0 and pass_IF3!=0 and pass_MAC1!=0 and pass_MAC2!=0 and pass_MAC3!=0:
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time+"\n")
        if pass_IF1==0:
            f.write("Packet from IF2 and/or IF3 has been recorded on IF1 when it should not\n")
        if pass_IF2==0:
            f.write("Packet from IF1 and/or IF3 has been recorded on IF2 when it should not\n")
        if pass_IF3==0:
            f.write("Packet from IF1 and/or IF2 has been recorded on IF3 when it should not\n")
        if pass_MAC1==0:
            f.write("MAC AA:AA:AA:AA:AA:AA not found on MAC table when it should not be")
        if pass_MAC2==0:
            f.write("MAC 00:BB:BB:BB:BB:BB not found on MAC table when it should not be")
        if pass_MAC3==0:
            f.write("MAC CC:CC:CC:CC:CC:CC not found on MAC table when it should not be")       
                 
                 
    f.close()
    return

def test_rstp_3_1_verifier(test):


    f=open("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap")
    pass_IF1=1
    count=0
    count2=0
    for i in array_pkts_IF1:
        if (i[Ether].src=="aa:aa:aa:aa:aa:aa" or i[Ether].src =="AA:AA:AA:AA:AA:AA") and (i[Ether].dst =="00:bb:bb:bb:bb:bb" or i[Ether].dst =="00:BB:BB:BB:BB:BB"):
            count=count+1
        if (i[Ether].src=="cc:cc:cc:cc:cc:cc" or i[Ether].src =="CC:CC:CC:CC:CC:CC") and (i[Ether].dst =="aa:aa:aa:aa:aa:aa" or i[Ether].dst =="AA:AA:AA:AA:AA:AA"):
            count2=count2+1
    if count==1000 and count2==1000:
        pass_IF1=1
    else:
        pass_IF1=0

    array_pkts_IF2=rdpcap("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap")
    pass_IF2=1
    count=0
    count2=0
    for i in array_pkts_IF2:
        if (i[Ether].src=="00:bb:bb:bb:bb:bb" or i[Ether].src =="00:BB:BB:BB:BB:BB") and (i[Ether].dst =="cc:cc:cc:cc:cc:cc" or i[Ether].dst =="CC:CC:CC:CC:CC:CC"):
            count=count+1
        if (i[Ether].src=="aa:aa:aa:aa:aa:aa" or i[Ether].src =="AA:AA:AA:AA:AA:AA") and (i[Ether].dst =="00:bb:bb:bb:bb:bb" or i[Ether].dst =="00:BB:BB:BB:BB:BB"):
            count2=count2+1
    if count==1000 and count2==1000:
        pass_IF2=1
    else:
        pass_IF2=0


    array_pkts_IF3=rdpcap("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap")

    pass_IF3=1
    count=0
    count2=0
    for i in array_pkts_IF3:
        if (i[Ether].src=="cc:cc:cc:cc:cc:cc" or i[Ether].src =="CC:CC:CC:CC:CC:CC") and (i[Ether].dst =="aa:aa:aa:aa:aa:aa" or i[Ether].dst =="AA:AA:AA:AA:AA:AA"):
            count=count+1
        if (i[Ether].src=="00:bb:bb:bb:bb:bb" or i[Ether].src =="00:BB:BB:BB:BB:BB") and (i[Ether].dst =="cc:cc:cc:cc:cc:cc" or i[Ether].dst =="CC:CC:CC:CC:CC:CC"):
            count2=count2+1
    if count==1000 and count2==1000:
        pass_IF3=1
    else:
        pass_IF3=0

    q=open("VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("mac_address_table get_port_entries "+data["port_0_name"])
    fin=out.find("mac_address_table get_port_entries "+data["port_1_name"])
    out_aux=out[inicio:fin]
    esta=out.find("AA:AA:AA:AA:AA:AA")
    esta2=out.find("aa:aa:aa:aa:aa:aa")
    if esta!=-1 or esta2!=-1:
        pass_MAC1=1
    else:
        pass_MAC1=0    
    

    inicio=out.find("mac_address_table get_port_entries "+data["port_1_name"])
    fin=out.find("mac_address_table get_port_entries "+data["port_2_name"])
    out_aux=out[inicio:fin]
    esta=out.find("00:BB:BB:BB:BB:BB") 
    esta2=out.find("00:bb:bb:bb:bb:bb")
    if esta!=-1 or esta2!=-1:
        pass_MAC2=1
    else:
        pass_MAC2=0


    
    inicio=out.find("mac_address_table get_port_entries "+data["port_2_name"])
    fin=out.find("mac_address_table get_port_entries "+data["port_3_name"])
    out_aux=out[inicio:fin]
    esta=out.find("CC:CC:CC:CC:CC:CC")
    esta2=out.find("cc:cc:cc:cc:cc:cc")
    if esta!=-1 or esta2!=-1:
        pass_MAC3=1
    else:
        pass_MAC3=0     
    
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_IF1!=0 and pass_IF2!=0 and pass_IF3!=0 and pass_MAC1!=0 and pass_MAC2!=0 and pass_MAC3!=0:
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail"+current_time+"\n")
        if pass_IF1==0:
            f.write("Packet from IF2 and/or IF3 has not been recorded on IF1 when it should \n")
        if pass_IF2==0:
            f.write("Packet from IF1 and/or IF3 has not been recorded on IF2 when it should \n")
        if pass_IF3==0:
            f.write("Packet from IF1 and/or IF2 has not been recorded on IF3 when it should \n")
        if pass_MAC1==0:
            f.write("MAC AA:AA:AA:AA:AA:AA not found on MAC table when it should not be")
        if pass_MAC2==0:
            f.write("MAC 00:BB:BB:BB:BB:BB not found on MAC table when it should not be")
        if pass_MAC3==0:
            f.write("MAC CC:CC:CC:CC:CC:CC not found on MAC table when it should not be")       
                 
                 
    f.close()
    return

def test_rstp_4_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 

    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0
    for i in array_pkts_IF1:
        if i[STP].rootmac==regional_root and i[STP].bridgemac==bridge_id:
            pass_=1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_==1:
        f.write("PASS\r"+current_time)
    else:
        f.write("FAIL\r"+current_time)
                 
                 
    f.close()

def test_rstp_5_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 

    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0
    primero=0
    delta=0
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].rootmac==regional_root:
                primero=1
                tiempo=i.time
            if i[STP].rootmac=='00:bf:cb:fc:bf:c0' and primero==1:
                delta=i.time-tiempo
                pass_=1
                break
                
    
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_==1:
        f.write("PASS\r"+current_time)
        if delta>1.4:
            f.write("The time interval between the last frame with a Root Bridge Identifier equal to the BridgeIdentifier of the DUT and the first frame with a Root Bridge Identifier of 0x7000 00BFCBFCBFC0 is greater than 1.4 seconds Delta Value:"+str(delta))
    else:
        f.write("FAIL\r"+current_time)
            
            
                 
                 
    f.close()

def test_rstp_6_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 

    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0

    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].proto==0 and i[STP].version==2 and i[STP].bpdutype==2 and (i[STP].bpduflags==124 or i[STP].bpduflags==60) and i[STP].rootmac==regional_root and i[STP].pathcost==0 and i[STP].bridgemac==regional_root and i[STP].age==0.0 and i[STP].maxage==20.0 and i[STP].hellotime==2.0 and i[STP].fwddelay==15.0 and i[STP].default_fields["version"]==0:
                pass_=1
                break


    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
                 
    f.close()

def test_rstp_7_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 

    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0

    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].proto==0 and i[STP].version==0 and i[STP].bpdutype==0 and  i[STP].bpduflags==0 and i[STP].rootmac==regional_root and i[STP].pathcost==0 and i[STP].bridgemac==regional_root and i[STP].age==0.0 and i[STP].maxage==20.0 and i[STP].hellotime==2.0 and i[STP].fwddelay==15.0 and i[STP].default_fields["version"]==0:
                pass_=1
                break


    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_8_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 

    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0

    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].proto==0 and i[STP].version==2 and i[STP].bpdutype==2  and i[STP].rootmac=='00:bf:cb:fc:bf:c0' and i[STP].pathcost==400000 and i[STP].bridgemac==regional_root and i[STP].age==2.0 and i[STP].maxage==40.0 and i[STP].hellotime==2.0 and i[STP].fwddelay==30.0 and i[STP].default_fields["version"]==0:
                pass_=1
                break


    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_9_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 

    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0

    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].proto==0 and i[STP].version==2 and i[STP].bpdutype==2  and i[STP].rootmac=='00:bf:cb:fc:bf:c0' and i[STP].pathcost==400000 and i[STP].bridgemac==regional_root and i[STP].age==2.0 and i[STP].maxage==40.0 and i[STP].hellotime==2.0 and i[STP].fwddelay==30.0 :
                pass_=1
                break


    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_10_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 

    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0

    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].proto==0 and i[STP].version==0 and i[STP].bpdutype==128:
                pass_=1
                break


    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_11_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].rootmac==regional_root:
                pass_=1
            mac=i.src
            mac=mac.lower()
            if i[STP].bpdutype==128 and mac!="aa:aa:aa:aa:aa:aa":
                pass_=0
                break
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            if STP in i:
                if i[STP].rootmac==regional_root:
                    pass_=1
                mac=i.src
                mac=mac.lower()
                if i[STP].bpdutype==128 and  mac!="bb:bb:bb:bb:bb:bb":
                    pass_=0
                    break
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            if STP in i:
                if i[STP].rootmac==regional_root:
                    pass_=1
                mac=i.src
                mac=mac.lower()
                if i[STP].bpdutype==128 and mac!="cc:cc:cc:cc:cc:cc":
                    pass_=0
                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_11_2_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].rootmac==regional_root:
                pass_=1
            mac=i.src
            mac=mac.lower()
            if i[STP].bpdutype==128 and mac!="aa:aa:aa:aa:aa:aa":
                pass_=0
                break
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            if STP in i:
                if i[STP].rootmac==regional_root:
                    pass_=1
                mac=i.src
                mac=mac.lower()
                if i[STP].bpdutype==128 and  mac!="bb:bb:bb:bb:bb:bb":
                    pass_=0
                    break
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            if STP in i:
                if i[STP].rootmac==regional_root:
                    pass_=1
                mac=i.src
                mac=mac.lower()
                if i[STP].bpdutype==128 and mac!="cc:cc:cc:cc:cc:cc":
                    pass_=0
                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_11_3_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=0
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].rootmac==regional_root:
                pass_=1
            mac=i.src
            mac=mac.lower()
            if i[STP].bpdutype==128 and mac!="aa:aa:aa:aa:aa:aa":
                pass_=0
                break
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            if STP in i:
                if i[STP].rootmac==regional_root:
                    pass_=1
                mac=i.src
                mac=mac.lower()
                if i[STP].bpdutype==128 and  mac!="bb:bb:bb:bb:bb:bb":
                    pass_=0
                    break
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            if STP in i:
                if i[STP].rootmac==regional_root:
                    pass_=1
                mac=i.src
                mac=mac.lower()
                if i[STP].bpdutype==128 and mac!="cc:cc:cc:cc:cc:cc":
                    pass_=0
                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_12_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=1
    uno=0
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==1:
                pass_=0
                break

            if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==0:
              uno=1
              pass_=0
              time=i.time


            if uno==1 and i[STP].rootmac==regional_root:
                delta=i.time-time
                if delta<1.2:
                    pass_=1
                else:
                    pass_=0
                    break

  
    uno=0
    time=0            
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            if STP in i:

                if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==1:
                    pass_=0
                    break

                if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==0:
                    uno=1
                    

    
    uno=0
    time=0       
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            if STP in i:

                if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==1:
                    pass_=0
                    break

                if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==0:
                    uno=1
                    pass_=0

                if uno==1 and i[STP].rootmac==regional_root:
                    delta=i.time-time
                    if delta<1.2:
                        pass_=1
                    else:
                        pass_=0
                        break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_12_2_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=1
    uno=0
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==1:
                pass_=0
                break

            if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==0:
              uno=1
              pass_=0
              time=i.time


            if uno==1 and i[STP].rootmac==regional_root:
                delta=i.time-time
                if delta<1.2:
                    pass_=1
                else:
                    pass_=0
                    break

    pass_=1
    uno=0
    time=0            
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            if STP in i:

                if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==1:
                    pass_=0
                    break

                if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==0:
                    uno=1
                    pass_=0

    pass_=1
    uno=0
    time=0       
    if pass_!=0:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            if STP in i:

                if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==1:
                    pass_=0
                    break

                if i[STP].bridgemac=="00:bf:cb:fc:bf:c1" and uno==0:
                    uno=1
                    pass_=0
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_13_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
   
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    prior=0
    pass_=0
    cont=0
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].rootid==prior:
                prior=prior+4096
                cont=cont+1

    if cont==16:
        pass_=1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_14_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
   
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    pass_=0
    cont=0
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].fwddelay==4 and cont==0:
                cont=cont+1
            if i[STP].fwddelay==15 and cont==1:
                cont=cont+1
            if i[STP].fwddelay==30 and cont==2:
                cont=cont+1
            if i[STP].fwddelay==12 and cont==3:
                cont=cont+1
            if i[STP].fwddelay==23 and cont==4:
                cont=cont+1    

    if cont==5:
        pass_=1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_15_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
   
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    pass_=0
    cont=0
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].maxage==6 and cont==0:
                cont=cont+1
            if i[STP].maxage==20 and cont==1:
                cont=cont+1
            if i[STP].maxage==28 and cont==2:
                cont=cont+1
            if i[STP].maxage==40 and cont==3:
                cont=cont+1

    if cont==4:
        pass_=1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_16_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
   
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    prior=0
    pass_=0
    cont=0
    for i in array_pkts_IF1:
        if STP in i:
            portid=str(hex(i[STP].portid))
            portid="0x"+portid[2:].zfill(4)
            portid=portid[2]
            aux=str(hex(prior))
            aux=aux[2]
            if portid==aux:
                prior=prior+16
                cont=cont+1

    if cont==16:
        pass_=1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_17_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
   
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    pass_=0
    cont=0
    for i in array_pkts_IF1:
        if STP in i:
            if i[STP].pathcost==1 and cont==0:
                cont=cont+1
            if i[STP].pathcost==2000 and cont==1:
                cont=cont+1
            if i[STP].pathcost==20000 and cont==2:
                cont=cont+1
            if i[STP].pathcost==200000 and cont==3:
                cont=cont+1
            if i[STP].pathcost==2000000 and cont==3:
                cont=cont+1
            if i[STP].pathcost==12345 and cont==3:
                cont=cont+1        

    if cont==6:
        pass_=1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_18_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=1
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
        cont_05=0
        cont_06=0
        cont_07=0
        cont_08=0
        cont_09=0
        cont_10=0
        
        for i in array_pkts_IF1:
            if i.src=="00:05:01:aa:05:11":
                cont_05=cont_05+1
            if i.src=="00:05:01:aa:06:22":
                pass_=0
                cont_06=cont_06+1
                break
            if i.src=="00:05:01:aa:07:33":
                cont_07=cont_07+1
            if i.src=="00:05:01:aa:08:11":
                cont_08=cont_08+1
            if i.src=="00:05:01:aa:09:22":
                cont_09=cont_09+1
            if i.src=="00:05:01:aa:10:33":
                cont_10=cont_10+1
        if cont_05==10 and cont_06==0 and cont_07==10 and cont_08==10 and cont_09==10 and cont_10==10:
            pass_=1
        else:
            pass_=0

    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        cont_05=0
        cont_06=0
        cont_07=0
        cont_08=0
        cont_09=0
        cont_10=0
        
        for i in array_pkts_IF1:
            if i.src=="00:05:01:aa:05:11":
                pass_=0
                cont_05=cont_05+1
                break
            if i.src=="00:05:01:aa:06:22":
                cont_06=cont_06+1
            if i.src=="00:05:01:aa:07:33":
                pass_=0
                cont_07=cont_07+1
                break
            if i.src=="00:05:01:aa:08:11":
                cont_08=cont_08+1
            if i.src=="00:05:01:aa:09:22":
                cont_09=cont_09+1
            if i.src=="00:05:01:aa:10:33":
                cont_10=cont_10+1
        if cont_05==0 and cont_06==10 and cont_07==0 and cont_08==10 and cont_09==10 and cont_10==10:
            pass_=1
        else:
            pass_=0           
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        cont_05=0
        cont_06=0
        cont_07=0
        cont_08=0
        cont_09=0
        cont_10=0
        
        for i in array_pkts_IF1:
            if i.src=="00:05:01:aa:05:11":
                cont_05=cont_05+1
            if i.src=="00:05:01:aa:06:22":
                pass_=0
                cont_06=cont_06+1
                break
            if i.src=="00:05:01:aa:07:33":
                cont_07=cont_07+1
            if i.src=="00:05:01:aa:08:11":
                cont_08=cont_08+1
            if i.src=="00:05:01:aa:09:22":
                cont_09=cont_09+1
            if i.src=="00:05:01:aa:10:33":
                cont_10=cont_10+1
        if cont_05==10 and cont_06==0 and cont_07==10 and cont_08==10 and cont_09==10 and cont_10==10:
            pass_=1
        else:
            pass_=0  

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()

def test_rstp_19_1_verifier(test):
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    inicio=out.find("bridge id")
    if inicio!=-1:
        bridge_id=out[inicio+25:inicio+25+17]
        bridge_id=bridge_id.lower()
    inicio=out.find("regional root")
    if inicio!=-1:    
        regional_root=out[inicio+25:inicio+25+17]
        regional_root=regional_root.lower()
    pass_=1
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
        cont_03=0
        cont_08=0

        for i in array_pkts_IF1:
            if i.src=="00:05:02:aa:03:11":
                cont_03=cont_03+1
            if i.src=="00:05:02:aa:08:11":
                cont_08=cont_08+1
    
        if cont_03==20 and cont_08==10 :
            pass_=1
        else:
            pass_=0

   
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        cont_03=0
        cont_08=0

        for i in array_pkts_IF1:
            if i.src=="00:05:02:aa:03:11":
                cont_03=cont_03+1
            if i.src=="00:05:02:aa:08:11":
                cont_08=cont_08+1
    
        if cont_03==10 and cont_08==20 :
            pass_=1
        else:
            pass_=0

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
                 
    f.close()


test="test_rstp_9_1"
config_type="soce_cli"
func="rstp"

"""
test=sys.argv[1]
config_type=sys.argv[2]
func=sys.argv[3]
"""
os.system("./bash_functions/soce_bash_functions.sh")
#filejson="/home/lab01/sw_develop/SOCE_TEST_24112021/soce_test/DUT_CONFIG_WEB/constants.json"
filejson=debug_path+"DUT_CONFIG_WEB/constants.json"
with open(filejson) as f:
    data = json.loads(f.read())
locals()[test+"_verifier"](test)
