

import scapy
import scapy.contrib.igmp
from scapy.all import *
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
def byte_string(byte):
    aux=str(hex(byte))
    aux=aux[2:]
    aux=aux.zfill(2)
    return aux
frames={
    "mac_dst": "",
    "mac_src":"",
    "length":"",
    "type":"",
    "logical_link_control":"",
    "protocol_id":"",
    "protocol_version_id":"",
    "BPDU_type":"",
    "CIST_flags":"",
    "CIST_root_id":"",
    "root_bridge_id_prior":"",
    "root_bridge_id":"",
    "CIST_ext_path_cost":"",
    "CIST_regional_root_id":"",
    "bridge_id_prior":"",
    "bridge_id":"",
    "port_id":"",
    "message_age":"",
    "max_age":"",
    "hello_time":"",
    "fwd_delay":"",
    "version_1_length":"",
    "version_3_length":"",
    "conf_id_format_selector":"",
    "conf_name":"",
    "revision_level":"",
    "msti_conf_digest":"",
    "CIST_int_path_cost":"",
    "CIST_bridge_prior_transmitting_bridge":"",
    "CIST_bridge_transmitting_bridge":"",
    "CIST_remaining_hops":"",
    "num_mstdi":"",
    "mstd_flag":"",
    "mstd_prior":"",
    "mstd_regional_root":"",
    "mstd_int_path_cost":"",
    "mstd_bridge_id_prior":"",
    "mstd_port_id_prior":"",
    "mstd_reamining_hops":""
}

def obtener_mstp(array):
    frame_mstp=0
    array_aux=bytes(array)
    frames.clear()
    frames["mac_dst"]=byte_string(array_aux[0])+":"+byte_string(array_aux[1])+":"+byte_string(array_aux[2])+":"+byte_string(array_aux[3])+":"+byte_string(array_aux[4])+":"+byte_string(array_aux[5])
    frames["mac_src"]=byte_string(array_aux[6])+":"+byte_string(array_aux[7])+":"+byte_string(array_aux[8])+":"+byte_string(array_aux[9])+":"+byte_string(array_aux[10])+":"+byte_string(array_aux[11])
    frames["length"]=byte_string(array_aux[12])
    frames["type"]=byte_string(array_aux[13])
    frames["logical_link_control"]=byte_string(array_aux[14])+byte_string(array_aux[15])+byte_string(array_aux[16])
    if frames["logical_link_control"]=="424203":
        frame_mstp=1
        frames["protocol_id"]=byte_string(array_aux[17])+byte_string(array_aux[18])
        frames["protocol_version_id"]=byte_string(array_aux[19])
        frames["BPDU_type"]=byte_string(array_aux[20])
        frames["CIST_flags"]=byte_string(array_aux[21])
        i=0
        
        frames["CIST_root_id"]=""
        while i<8:
            frames["CIST_root_id"]=frames["CIST_root_id"]+byte_string(array_aux[22+i])
            i=i+1
        frames["root_bridge_id_prior"]=int(int(byte_string(array_aux[22]),16)*4096/16)
        i=0
        
        frames["root_bridge_id"]=""
        while i<6:
            frames["root_bridge_id"]=frames["root_bridge_id"]+byte_string(array_aux[24+i])
            if i!=5:
                frames["root_bridge_id"]=frames["root_bridge_id"]+":"
            i=i+1
        frames["CIST_ext_path_cost"]=int(byte_string(array_aux[30])+byte_string(array_aux[31])+byte_string(array_aux[32])+byte_string(array_aux[33]),16)

        i=0    
        frames["CIST_regional_root_id"]=""
        while i<8:
            frames["CIST_regional_root_id"]=frames["CIST_regional_root_id"]+byte_string(array_aux[34+i])
            i=i+1
        frames["bridge_id_prior"]=int(int(byte_string(array_aux[34]),16)*4096/16)
        i=0
        
        frames["bridge_id"]=""
        while i<6:
            frames["bridge_id"]=frames["bridge_id"]+byte_string(array_aux[36+i])
            if i!=5:
                frames["bridge_id"]=frames["bridge_id"]+":"
            i=i+1
        frames["port_id"]=byte_string(array_aux[42])+byte_string(array_aux[43])
        frames["message_age"]=int(int(byte_string(array_aux[44])+byte_string(array_aux[45]),16)/256)
        frames["max_age"]=int(int(byte_string(array_aux[46])+byte_string(array_aux[47]),16)/256)
        frames["hello_time"]=int(int(byte_string(array_aux[48])+byte_string(array_aux[49]),16)/256)
        frames["fwd_delay"]=int(int(byte_string(array_aux[50])+byte_string(array_aux[51]),16)/256)
        frames["version_1_length"]=int(byte_string(array_aux[52]),16)
        frames["version_3_length"]=int(byte_string(array_aux[53])+byte_string(array_aux[54]),16)
        if frames["version_3_length"]>=64 and frames["version_3_length"]!=65535:
            frames["conf_id_format_selector"]=byte_string(array_aux[55])
            frames["conf_name"]=""
            i=0
            while i<32:
                frames["conf_name"]=frames["conf_name"]+byte_string(array_aux[56+i])
                i=i+1


            frames["revision_level"]=int(byte_string(array_aux[88])+byte_string(array_aux[89]),16)
            frames["msti_conf_digest"]=""
            i=0
            while i<16:
                frames["msti_conf_digest"]=frames["msti_conf_digest"]+byte_string(array_aux[90+i])
                i=i+1

            frames["CIST_int_path_cost"]=int(byte_string(array_aux[106])+byte_string(array_aux[107])+byte_string(array_aux[108])+byte_string(array_aux[109]),16)
            frames["CIST_bridge_prior_transmitting_bridge"]=int(int(byte_string(array_aux[110]),16)*4096/16)
            i=0
            
            frames["CIST_bridge_transmitting_bridge"]=""
            while i<6:
                frames["CIST_bridge_transmitting_bridge"]=frames["CIST_bridge_transmitting_bridge"]+byte_string(array_aux[112+i])
                if i!=5:
                    frames["CIST_bridge_transmitting_bridge"]=frames["CIST_bridge_transmitting_bridge"]+":"
                i=i+1
            frames["CIST_remaining_hops"]=int(byte_string(array_aux[118]),16)
            i=80
            j=0
            frames["num_mstdi"]=0
            frames["mstd_flag"]=[]
            frames["mstd_prior"]=[]
            frames["mstd_regional_root"]=[]
            frames["mstd_int_path_cost"]=[]
            frames["mstd_bridge_id_prior"]=[]
            frames["mstd_port_id_prior"]=[]
            frames["mstd_reamining_hops"]=[]
            
            while i<=frames["version_3_length"] and (frames["version_3_length"]-i>=16 or frames["version_3_length"]-i==0):
                frames["mstd_flag"].append(byte_string(array_aux[119+(j*16)]))
                frames["mstd_prior"].append(byte_string(array_aux[120+(j*16)])+byte_string(array_aux[121+(j*16)]))
                aux_regional_root=""
                k=0
                while k<6:
                    aux_regional_root=aux_regional_root+byte_string(array_aux[122+k+(j*16)])
                    if k!=5:
                        aux_regional_root=aux_regional_root+":"
                    k=k+1
                frames["mstd_regional_root"].append(aux_regional_root)
                frames["mstd_int_path_cost"].append(int(byte_string(array_aux[128+(j*16)])+byte_string(array_aux[129+(j*16)])+byte_string(array_aux[130+(j*16)])+byte_string(array_aux[131+(j*16)]),16))         
                frames["mstd_bridge_id_prior"].append(int(int(byte_string(array_aux[132+(j*16)]),16)/16))
                frames["mstd_port_id_prior"].append(int(int(byte_string(array_aux[133+(j*16)]),16)/16))
                frames["mstd_reamining_hops"].append(int(byte_string(array_aux[134+(j*16)]),16))
                j=j+1
                frames["num_mstdi"]=j
                i=i+16

    return frame_mstp

def test_mstp_1_1_verifier(test): 
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    i=0
    pass_=1
    while i<4 and pass_==1:
        inicio=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames>=2000 and i==0:
            pass_=1
        elif good_frames<2000 and i==2:
            pass_=1
        elif good_frames>=2000 and i==1:
            pass_=1
        elif good_frames<2000 and i==3:
            pass_=1

        else:
            pass_=0
       
        i=i+1
    i=0
    while i<4 and pass_==1:
        inicio=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames<2000:
            pass_=1
        else:
            pass_=0
        
        i=i+1

    while i<4 and pass_==1:
        inicio=out.find("mac_address_table get_port_entries "+data["port_"+str(i)+"_name"])
        fin=out.find("mac_address_table get_port_entries "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        esta=out_aux.find("00:02:02:02:02:01")
        if esta==-1:
         pass_=1
        else:
            pass_=0
            break


        esta=out_aux.find("00:02:02:02:02:02")
        if esta==-1:
         pass_=1
        else:
            pass_=0
            break

        esta=out_aux.find("00:02:02:02:02:03")
        if esta==-1:
         pass_=1
        else:
            pass_=0
            break


        esta=out_aux.find("00:02:02:02:02:04")
        if esta==-1:
         pass_=1
        else:
            pass_=0
            break

        
        i=i+1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()
    
def test_mstp_1_2_verifier(test): 
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    i=0
    pass_=1
    while i<4 and pass_==1:
        inicio=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames>=2000 and i==0:
            pass_=1
        elif good_frames<2000 and i==2:
            pass_=1
        elif good_frames>=2000 and i==1:
            pass_=1
        elif good_frames<2000 and i==3:
            pass_=1

        else:
            pass_=0
       
        i=i+1
    i=0
    while i<4 and pass_==1:
        inicio=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames<2000:
            pass_=1
        else:
            pass_=0
        
        i=i+1

    while i<4 and pass_==1:
        inicio=out.find("mac_address_table get_port_entries "+data["port_"+str(i)+"_name"])
        fin=out.find("mac_address_table get_port_entries "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        esta=out_aux.find("00:02:02:02:02:01")
        if esta==-1:
         pass_=1
        else:
            pass_=0
            break


        esta=out_aux.find("00:02:02:02:02:02")
        if esta==-1:
         pass_=1
        else:
            pass_=0
            break

        esta=out_aux.find("00:02:02:02:02:03")
        if esta==-1:
         pass_=1
        else:
            pass_=0
            break


        esta=out_aux.find("00:02:02:02:02:04")
        if esta==-1:
         pass_=1
        else:
            pass_=0
            break

        
        i=i+1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()
   
def test_mstp_1_3_verifier(test): 
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    i=0
    pass_=1
    while i<4 and pass_==1:
        inicio=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames<2000 and i==0:
            pass_=1
        elif good_frames<2000 and i==2:
            pass_=1
        elif good_frames<2000 and i==1:
            pass_=1
        elif good_frames<2000 and i==3:
            pass_=1

        else:
            pass_=0
       
        i=i+1
    i=0
    while i<4 and pass_==1:
        inicio=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames<2000:
            pass_=1
        else:
            pass_=0
        
        i=i+1
    i=0
    while i<4 and pass_==1:
        inicio=out.find("mac_address_table get_port_entries "+data["port_"+str(i)+"_name"])
        fin=out.find("mac_address_table get_port_entries "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        
        if i==0:
            esta=out_aux.find("00:02:02:02:02:01")

            if esta!=-1 :
                out_aux=out_aux[esta:]
                inicio=out_aux.find("VID")
                fin=out_aux.find("|",inicio)
                vid=int(out_aux[inicio+8:fin])
                if vid==5:
                    pass_=1
                else:
                    pass_=0
                    break
            else:
                pass_=0
                break
        if i==1:
            esta=out_aux.find("00:02:02:02:02:02")
            if esta==-1:
                pass_=1
            else:
                pass_=0
                break
        if i==2:
            esta=out_aux.find("00:02:02:02:02:03")
            if esta!=-1:
                if esta!=-1 :
                    out_aux=out_aux[esta:]
                    inicio=out_aux.find("VID")
                    fin=out_aux.find("|",inicio)
                    vid=int(out_aux[inicio+8:fin])
                    if vid==7:
                        pass_=1
                    else:
                        pass_=0
                        break
                
            else:
                pass_=0
                break
        if i==3:
            esta=out_aux.find("00:02:02:02:02:04")
            if esta==-1:
                pass_=1
            else:
                pass_=0
                break
        
            

        
        i=i+1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_1_4_verifier(test): 
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    i=0
    pass_=1
    """
    while i<4 and pass_==1:
        inicio=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames<2000 and i==0:
            pass_=1
        elif good_frames<2000 and i==1:
            pass_=1
        elif good_frames<2000 and i==2:
            pass_=1
        elif good_frames<2000 and i==3:
            pass_=1

        else:
            pass_=0
       
        i=i+1
    """
    i=0
    while i<4 and pass_==1:
        inicio=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames<2000:
            pass_=1
        else:
            pass_=0
        
        i=i+1
    i=0
    while i<4 and pass_==1:
        inicio=out.find("mac_address_table get_port_entries "+data["port_"+str(i)+"_name"])
        fin=out.find("mac_address_table get_port_entries "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        
        if i==0:
            esta=out_aux.find("00:02:02:02:02:01")

            if esta!=-1 :
                out_aux=out_aux[esta:]
                inicio=out_aux.find("VID")
                fin=out_aux.find("|",inicio)
                vid=int(out_aux[inicio+8:fin])
                if vid==7:
                    pass_=1
                else:
                    pass_=0
                    break
            else:
                pass_=0
                break
        if i==1:
            esta=out_aux.find("00:02:02:02:02:02")
            if esta==-1:
                pass_=1
            else:
                pass_=0
                break
        if i==2:
            esta=out_aux.find("00:02:02:02:02:03")
            if esta!=-1:
                if esta!=-1 :
                    out_aux=out_aux[esta:]
                    inicio=out_aux.find("VID")
                    fin=out_aux.find("|",inicio)
                    vid=int(out_aux[inicio+8:fin])
                    if vid==5:
                        pass_=1
                    else:
                        pass_=0
                        break
                
            else:
                pass_=0
                break
        if i==3:
            esta=out_aux.find("00:02:02:02:02:04")
            if esta==-1:
                pass_=1
            else:
                pass_=0
                break
        
            

        
        i=i+1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_1_5_verifier(test): 
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    i=0
    pass_=1
    """"
    while i<4 and pass_==1:
        inicio=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames<2000 and i==0:
            pass_=1
        elif good_frames<2000 and i==1:
            pass_=1
        elif good_frames<2000 and i==2:
            pass_=1
        elif good_frames<2000 and i==3:
            pass_=1

        else:
            pass_=0
       
        i=i+1
    """
    i=0
    while i<4 and pass_==1:
        inicio=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if i==0 or i==2:
            if good_frames<2000 and good_frames>1000 :
                pass_=1
            else:
                pass_=0
        
        i=i+1
    i=0
    while i<4 and pass_==1:
        inicio=out.find("mac_address_table get_port_entries "+data["port_"+str(i)+"_name"])
        fin=out.find("mac_address_table get_port_entries "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        
        if i==0:
            esta=out_aux.find("00:02:02:02:02:01")

            if esta!=-1 :
                out_aux=out_aux[esta:]
                inicio=out_aux.find("VID")
                fin=out_aux.find("|",inicio)
                vid=int(out_aux[inicio+8:fin])
                if vid==5:
                    pass_=1
                else:
                    pass_=0
                    break
            else:
                pass_=0
                break
        if i==1:
            esta=out_aux.find("00:02:02:02:02:02")
            if esta==-1:
                pass_=1
            else:
                pass_=0
                break
        if i==2:
            esta=out_aux.find("00:02:02:02:02:03")
            if esta!=-1:
                if esta!=-1 :
                    out_aux=out_aux[esta:]
                    inicio=out_aux.find("VID")
                    fin=out_aux.find("|",inicio)
                    vid=int(out_aux[inicio+8:fin])
                    if vid==5:
                        pass_=1
                    else:
                        pass_=0
                        break
                
            else:
                pass_=0
                break
        if i==3:
            esta=out_aux.find("00:02:02:02:02:04")
            if esta==-1:
                pass_=1
            else:
                pass_=0
                break
        
            

        
        i=i+1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_1_6_verifier(test): 
    f=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_result.out","w+")
    
    q=open(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+".out")
    out=q.read()
    i=0
    pass_=1
    """"
    while i<4 and pass_==1:
        inicio=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_rx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if good_frames<2000 and i==0:
            pass_=1
        elif good_frames<2000 and i==1:
            pass_=1
        elif good_frames<2000 and i==2:
            pass_=1
        elif good_frames<2000 and i==3:
            pass_=1

        else:
            pass_=0
       
        i=i+1
    """
    i=0
    while i<4 and pass_==1:
        inicio=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i)+"_name"])
        fin=out.find("statistics get_tx_basic_statistics "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        inicio=out_aux.find("Good frames")
        fin=out_aux.find("|",inicio)
        good_frames=int(out_aux[inicio+16:fin])
        if i==0 or i==2:
            if good_frames<2000 and good_frames>1000 :
                pass_=1
            else:
                pass_=0
        
        i=i+1
    i=0
    while i<4 and pass_==1:
        inicio=out.find("mac_address_table get_port_entries "+data["port_"+str(i)+"_name"])
        fin=out.find("mac_address_table get_port_entries "+data["port_"+str(i+1)+"_name"])
        out_aux=out[inicio:fin]
        
        if i==0:
            esta=out_aux.find("00:02:02:02:02:01")

            if esta!=-1 :
                out_aux=out_aux[esta:]
                inicio=out_aux.find("VID")
                fin=out_aux.find("|",inicio)
                vid=int(out_aux[inicio+8:fin])
                if vid==7:
                    pass_=1
                else:
                    pass_=0
                    break
            else:
                pass_=0
                break
        if i==1:
            esta=out_aux.find("00:02:02:02:02:02")
            if esta==-1:
                pass_=1
            else:
                pass_=0
                break
        if i==2:
            esta=out_aux.find("00:02:02:02:02:03")
            if esta!=-1:
                if esta!=-1 :
                    out_aux=out_aux[esta:]
                    inicio=out_aux.find("VID")
                    fin=out_aux.find("|",inicio)
                    vid=int(out_aux[inicio+8:fin])
                    if vid==7:
                        pass_=1
                    else:
                        pass_=0
                        break
                
            else:
                pass_=0
                break
        if i==3:
            esta=out_aux.find("00:02:02:02:02:04")
            if esta==-1:
                pass_=1
            else:
                pass_=0
                break
        
            

        
        i=i+1
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_2_1_verifier(test):
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
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            forwarding= bool(int(frames["CIST_flags"],16)&0b00100000)
            designated= bool(int(frames["CIST_flags"],16)&0b00001100)
            if frames["num_mstdi"]>0:
                forwarding_mstd0= bool(int(frames["mstd_flag"][0],16)&0b00100000)
                designated_mstd0= bool(int(frames["mstd_flag"][0],16)&0b00001100)
            else:
                forwarding_mstd0=False
                designated_mstd0=False
            if frames["num_mstdi"]>1:
                forwarding_mstd1= bool(int(frames["mstd_flag"][1],16)&0b00100000)
                designated_mstd1= bool(int(frames["mstd_flag"][1],16)&0b00001100)
            else:
                forwarding_mstd1=False
                designated_mstd1=False
            pass_=0
            if frames["protocol_id"] ==  "0000":
                if frames["protocol_version_id"]=="03":
                    if frames["BPDU_type"]=="02":
                        if forwarding==True:
                            if designated==True:
                                if frames["root_bridge_id"]==regional_root:
                                    if frames["CIST_ext_path_cost"]==0:
                                        if frames["bridge_id"]==bridge_id:
                                            if frames["message_age"]==0:
                                                if frames["max_age"]==20:
                                                    if frames["hello_time"]==2:
                                                        if frames["fwd_delay"]==15:
                                                            if frames["version_1_length"]==0:
                                                                if frames["CIST_int_path_cost"]==0:
                                                                    if frames["CIST_bridge_transmitting_bridge"]:
                                                                        if frames["CIST_remaining_hops"]==20:
                                                                            if forwarding_mstd0==True:
                                                                                if designated_mstd0==True:
                                                                                    if frames["mstd_regional_root"][0]==regional_root:
                                                                                        if frames["mstd_int_path_cost"][0]==0:
                                                                                            if frames["mstd_bridge_id_prior"][0]==9:
                                                                                                if frames["mstd_port_id_prior"][0]==8:
                                                                                                    if frames["mstd_reamining_hops"][0]==20:
                                                                                                        if forwarding_mstd1==True:
                                                                                                            if designated_mstd1==True:
                                                                                                                if frames["mstd_regional_root"][1]==regional_root:
                                                                                                                    if frames["mstd_int_path_cost"][1]==0:
                                                                                                                        if frames["mstd_bridge_id_prior"][1]==10:
                                                                                                                            if frames["mstd_port_id_prior"][1]==8:
                                                                                                                                if frames["mstd_reamining_hops"][1]==20:
                                                                                                                                    pass_=1
                                                                                                                                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_2_2_verifier(test):
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
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            forwarding= bool(int(frames["CIST_flags"],16)&0b00100000)
            designated= bool(int(frames["CIST_flags"],16)&0b00001100)
            if frames["num_mstdi"]>0:
                forwarding_mstd0= bool(int(frames["mstd_flag"][0],16)&0b00100000)
                designated_mstd0= bool(int(frames["mstd_flag"][0],16)&0b00001100)
            else:
                forwarding_mstd0=False
                designated_mstd0=False
            if frames["num_mstdi"]>1:
                forwarding_mstd1= bool(int(frames["mstd_flag"][1],16)&0b00100000)
                designated_mstd1= bool(int(frames["mstd_flag"][1],16)&0b00001100)
            else:
                forwarding_mstd1=False
                designated_mstd1=False
            pass_=0
            if frames["protocol_id"] ==  "0000":
                if frames["protocol_version_id"]=="03":
                    if frames["BPDU_type"]=="02":
                        if forwarding==True:
                            if designated==True:
                                if frames["root_bridge_id"]==regional_root:
                                    if frames["CIST_ext_path_cost"]==0:
                                        if frames["bridge_id"]==bridge_id:
                                            if frames["message_age"]==0:
                                                if frames["max_age"]==20:
                                                    if frames["hello_time"]==2:
                                                        if frames["fwd_delay"]==15:
                                                            if frames["version_1_length"]==0:
                                                                if frames["CIST_int_path_cost"]==0:
                                                                    if frames["CIST_bridge_transmitting_bridge"]:
                                                                        if frames["CIST_remaining_hops"]==20:
                                                                            if forwarding_mstd0==True:
                                                                                if designated_mstd0==True:
                                                                                    if frames["mstd_regional_root"][0]==regional_root:
                                                                                        if frames["mstd_int_path_cost"][0]==0:
                                                                                            if frames["mstd_bridge_id_prior"][0]==9:
                                                                                                if frames["mstd_port_id_prior"][0]==8:
                                                                                                    if frames["mstd_reamining_hops"][0]==20:
                                                                                                        if forwarding_mstd1==True:
                                                                                                            if designated_mstd1==True:
                                                                                                                if frames["mstd_regional_root"][1]==regional_root:
                                                                                                                    if frames["mstd_int_path_cost"][1]==0:
                                                                                                                        if frames["mstd_bridge_id_prior"][1]==10:
                                                                                                                            if frames["mstd_port_id_prior"][1]==8:
                                                                                                                                if frames["mstd_reamining_hops"][1]==20:
                                                                                                                                    pass_=1
                                                                                                                                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_2_3_verifier(test):
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

    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
    
   
    pass_=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            forwarding= bool(int(frames["CIST_flags"],16)&0b00100000)
            designated= bool(int(frames["CIST_flags"],16)&0b00001100)
            if frames["num_mstdi"]>0:
                forwarding_mstd0= bool(int(frames["mstd_flag"][0],16)&0b00100000)
                designated_mstd0= bool(int(frames["mstd_flag"][0],16)&0b00001100)
            else:
                forwarding_mstd0=False
                designated_mstd0=False
            if frames["num_mstdi"]>1:
                forwarding_mstd1= bool(int(frames["mstd_flag"][1],16)&0b00100000)
                designated_mstd1= bool(int(frames["mstd_flag"][1],16)&0b00001100)
            else:
                forwarding_mstd1=False
                designated_mstd1=False
            pass_=0
            if frames["protocol_id"] ==  "0000":
                if frames["protocol_version_id"]=="03":
                    if frames["BPDU_type"]=="02":
                        if forwarding==True:
                            if designated==True:
                                if frames["root_bridge_id"]=="00:bf:cb:fc:bf:c0":
                                    if frames["CIST_ext_path_cost"]==220000:
                                        if frames["bridge_id"]==bridge_id:
                                            if frames["message_age"]==2:
                                                if frames["max_age"]==20:
                                                    if frames["hello_time"]==2:
                                                        if frames["fwd_delay"]==15:
                                                            if frames["version_1_length"]==0:
                                                                if frames["CIST_int_path_cost"]==0:
                                                                    if frames["CIST_bridge_transmitting_bridge"]:
                                                                        if frames["CIST_remaining_hops"]==20:
                                                                            if forwarding_mstd0==True:
                                                                                if designated_mstd0==True:
                                                                                    if frames["mstd_regional_root"][0]==regional_root:
                                                                                        if frames["mstd_int_path_cost"][0]==0:
                                                                                            if frames["mstd_bridge_id_prior"][0]==9:
                                                                                                if frames["mstd_port_id_prior"][0]==8:
                                                                                                    if frames["mstd_reamining_hops"][0]==20:
                                                                                                        if forwarding_mstd1==True:
                                                                                                            if designated_mstd1==True:
                                                                                                                if frames["mstd_regional_root"][1]==regional_root:
                                                                                                                    if frames["mstd_int_path_cost"][1]==0:
                                                                                                                        if frames["mstd_bridge_id_prior"][1]==10:
                                                                                                                            if frames["mstd_port_id_prior"][1]==8:
                                                                                                                                if frames["mstd_reamining_hops"][1]==20:
                                                                                                                                    pass_=1
                                                                                                                                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_2_4_verifier(test):
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
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            forwarding= bool(int(frames["CIST_flags"],16)&0b00100000)
            designated= bool(int(frames["CIST_flags"],16)&0b00001100)
            if frames["num_mstdi"]>0:
                forwarding_mstd0= bool(int(frames["mstd_flag"][0],16)&0b00100000)
                designated_mstd0= bool(int(frames["mstd_flag"][0],16)&0b00001100)
            else:
                forwarding_mstd0=False
                designated_mstd0=False
            if frames["num_mstdi"]>1:
                forwarding_mstd1= bool(int(frames["mstd_flag"][1],16)&0b00100000)
                designated_mstd1= bool(int(frames["mstd_flag"][1],16)&0b00001100)
            else:
                forwarding_mstd1=False
                designated_mstd1=False
            pass_=0
            if frames["protocol_id"] ==  "0000":
                if frames["protocol_version_id"]=="03":
                    if frames["BPDU_type"]=="02":
                        if forwarding==True:
                            if designated==True:
                                if frames["root_bridge_id"]==regional_root:
                                    if frames["CIST_ext_path_cost"]==0:
                                        if frames["bridge_id"]==bridge_id:
                                            if frames["message_age"]==0:
                                                if frames["max_age"]==20:
                                                    if frames["hello_time"]==2:
                                                        if frames["fwd_delay"]==15:
                                                            if frames["version_1_length"]==0:
                                                                if frames["CIST_int_path_cost"]==0:
                                                                    if frames["CIST_bridge_transmitting_bridge"]:
                                                                        if frames["CIST_remaining_hops"]==20:
                                                                            if forwarding_mstd0==True:
                                                                                if designated_mstd0==True:
                                                                                    if frames["mstd_regional_root"][0]==regional_root:
                                                                                        if frames["mstd_int_path_cost"][0]==0:
                                                                                            if frames["mstd_bridge_id_prior"][0]==9:
                                                                                                if frames["mstd_port_id_prior"][0]==8:
                                                                                                    if frames["mstd_reamining_hops"][0]==20:
                                                                                                        if forwarding_mstd1==True:
                                                                                                            if designated_mstd1==True:
                                                                                                                if frames["mstd_regional_root"][1]==regional_root:
                                                                                                                    if frames["mstd_int_path_cost"][1]==0:
                                                                                                                        if frames["mstd_bridge_id_prior"][1]==10:
                                                                                                                            if frames["mstd_port_id_prior"][1]==8:
                                                                                                                                if frames["mstd_reamining_hops"][1]==20:
                                                                                                                                    pass_=1
                                                                                                                                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_3_1_verifier(test):
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
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa":
                esta=1
            if frames["bridge_id"]==bridge_id and esta==1:
                pass_=1
                break
    
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["mac_src"]=="bb:bb:bb:bb:bb:bb":
                    esta=1
                if frames["bridge_id"]==bridge_id and esta==1:
                    pass_=1
                    break
    
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                if frames["CIST_flags"]=="7e":
                    esta=1
                if frames["bridge_id"]==bridge_id and esta==1:
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_4_1_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" :
                root_bridge_id=frames["root_bridge_id"]
                
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_5_1_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" :
                CIST_bridge_transmitting_bridge=bridge_id
                
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                
                if frames["root_bridge_id"]==CIST_bridge_transmitting_bridge and frames["CIST_flags"]=="7f":
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==CIST_bridge_transmitting_bridge and frames["CIST_flags"]=="7f":
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_6_1_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                root_bridge_id=frames["root_bridge_id"]
                esta=1
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["root_bridge_id"]!=root_bridge_id:
                root_bridge_id2=frames["root_bridge_id"]
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                   esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break
    if pass_==1 and   os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"): 
                   
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_6_2_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                root_bridge_id=frames["root_bridge_id"]
                esta=1
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["root_bridge_id"]!=root_bridge_id:
                root_bridge_id2=frames["root_bridge_id"]
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                   esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break
    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_6_3_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                root_bridge_id=frames["root_bridge_id"]
                esta=1
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["root_bridge_id"]!=root_bridge_id:
                root_bridge_id2=frames["root_bridge_id"]
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                   esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break
    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_6_4_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                root_bridge_id=frames["root_bridge_id"]
                esta=1
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["root_bridge_id"]!=root_bridge_id:
                root_bridge_id2=frames["root_bridge_id"]
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                   esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break
    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id :
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2:
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_7_1_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                root_bridge_id=frames["root_bridge_id"]
                external_root_path_cost=frames["CIST_ext_path_cost"]
                esta=1
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["CIST_ext_path_cost"]!=external_root_path_cost and esta==1:
                root_bridge_id2=frames["root_bridge_id"]
                external_root_path_cost2=frames["CIST_ext_path_cost"] 
                esta=2
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["CIST_ext_path_cost"]!=external_root_path_cost and frames["CIST_ext_path_cost"]!=external_root_path_cost2:
                root_bridge_id3=frames["root_bridge_id"]
                external_root_path_cost3=frames["CIST_ext_path_cost"]            
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                 
                if frames["root_bridge_id"]==root_bridge_id and frames["CIST_ext_path_cost"]==external_root_path_cost:
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2 and frames["CIST_ext_path_cost"]==external_root_path_cost2:
                    esta=2
                if esta==2 and frames["root_bridge_id"]==root_bridge_id3 and frames["CIST_ext_path_cost"]==external_root_path_cost3:    
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id and frames["CIST_ext_path_cost"]==external_root_path_cost:
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2 and frames["CIST_ext_path_cost"]==external_root_path_cost2:
                    esta=2
                if esta==2 and frames["root_bridge_id"]==root_bridge_id3 and frames["CIST_ext_path_cost"]==external_root_path_cost3:    
                    pass_=1
                    break
    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id and frames["CIST_ext_path_cost"]==external_root_path_cost:
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2 and frames["CIST_ext_path_cost"]==external_root_path_cost2:
                    esta=2
                if esta==2 and frames["root_bridge_id"]==root_bridge_id3 and frames["CIST_ext_path_cost"]==external_root_path_cost3:    
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_7_2_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                root_bridge_id=frames["root_bridge_id"]
                external_root_path_cost=frames["CIST_ext_path_cost"]+200000
                esta=1
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["CIST_ext_path_cost"]!=external_root_path_cost and esta==1:
                root_bridge_id2=frames["root_bridge_id"]
                external_root_path_cost2=frames["CIST_ext_path_cost"]+200000 
                esta=2
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["CIST_ext_path_cost"]!=external_root_path_cost and frames["CIST_ext_path_cost"]!=external_root_path_cost2:
                root_bridge_id3=frames["root_bridge_id"]
                external_root_path_cost3=frames["CIST_ext_path_cost"]+200000            
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                 
                if frames["root_bridge_id"]==root_bridge_id and frames["CIST_ext_path_cost"]==external_root_path_cost:
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2 and frames["CIST_ext_path_cost"]==external_root_path_cost2:
                    esta=2
                if esta==2 and frames["root_bridge_id"]==root_bridge_id3 and frames["CIST_ext_path_cost"]==external_root_path_cost3:    
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id and frames["CIST_ext_path_cost"]==external_root_path_cost:
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2 and frames["CIST_ext_path_cost"]==external_root_path_cost2:
                    esta=2
                if esta==2 and frames["root_bridge_id"]==root_bridge_id3 and frames["CIST_ext_path_cost"]==external_root_path_cost3:    
                    pass_=1
                    break
    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                
                if frames["root_bridge_id"]==root_bridge_id and frames["CIST_ext_path_cost"]==external_root_path_cost:
                    esta=1
                if esta==1 and frames["root_bridge_id"]==root_bridge_id2 and frames["CIST_ext_path_cost"]==external_root_path_cost2:
                    esta=2
                if esta==2 and frames["root_bridge_id"]==root_bridge_id3 and frames["CIST_ext_path_cost"]==external_root_path_cost3:    
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_8_1_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                regional_root_identifier=frames["CIST_regional_root_id"]
                esta=1
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["CIST_regional_root_id"]!=regional_root_identifier and esta==1:
                regional_root_identifier2=frames["CIST_regional_root_id"]  
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                 
                if frames["CIST_regional_root_id"]==regional_root_identifier: 
                    esta=1
                if esta==1 and frames["CIST_regional_root_id"]==regional_root_identifier2:
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                 
                if frames["CIST_regional_root_id"]==regional_root_identifier: 
                    esta=1
                if esta==1 and frames["CIST_regional_root_id"]==regional_root_identifier2:
                        
                    pass_=1
                    break
    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                                
                if frames["CIST_regional_root_id"]==regional_root_identifier: 
                    esta=1
                if esta==1 and frames["CIST_regional_root_id"]==regional_root_identifier2:
                       
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_8_2_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    regional_root_identifier=""
    regional_root_identifier2=""
    regional_root_identifier3=""
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                regional_root_identifier=frames["CIST_regional_root_id"]
                esta=1
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and frames["CIST_regional_root_id"]!=regional_root_identifier and esta==1:
                regional_root_identifier2=frames["CIST_regional_root_id"] 
                            
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                 
                if frames["CIST_regional_root_id"]==regional_root_identifier: 
                    esta=1
                if esta==1 and frames["CIST_regional_root_id"]==regional_root_identifier2:
                        
                    pass_=1
                    break

    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                 
                if frames["CIST_regional_root_id"]==regional_root_identifier: 
                    esta=1
                if esta==1 and frames["CIST_regional_root_id"]==regional_root_identifier2:
                        
                    pass_=1
                    break
    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                                
                if frames["CIST_regional_root_id"]==regional_root_identifier: 
                    esta=1
                if esta==1 and frames["CIST_regional_root_id"]==regional_root_identifier2:    
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_8_3_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    regional_root_identifier=""
    regional_root_identifier2=""
    regional_root_identifier3=""
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                regional_root_identifier=frames["CIST_regional_root_id"]
                                      
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                 
                if frames["CIST_regional_root_id"]==regional_root_identifier: 
                                         
                    pass_=1
                    break


    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                                
                if frames["CIST_regional_root_id"]==regional_root_identifier: 
                    
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_8_4_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        
   
    esta=0
    regional_root_identifier=""
    regional_root_identifier2=""
    regional_root_identifier3=""
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                regional_root_identifier=frames["CIST_regional_root_id"]    
                break
    if pass_==1:        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                 
                if frames["CIST_regional_root_id"]==regional_root_identifier:
                    pass_=1
                    break


    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        
        pass_=0
        esta=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)

            if frame_mstp==1:
                                
                if frames["CIST_regional_root_id"]==regional_root_identifier:
                    pass_=1
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_8_5_verifier(test):
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
    count=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            if frames["root_bridge_id_prior"]==61440 and frames["bridge_id_prior"]==61440 and count==0:
                count=count+1    
            if frames["root_bridge_id_prior"]==40960 and frames["bridge_id_prior"]==40960 and count==1:
                count=count+1 
            if frames["root_bridge_id_prior"]==24576 and frames["bridge_id_prior"]==24576 and count==2:
                count=count+1 
            if frames["root_bridge_id_prior"]==12288 and frames["bridge_id_prior"]==12288 and count==3:
                count=count+1 
            if frames["root_bridge_id_prior"]==0 and frames["bridge_id_prior"]==0 and count==4:
                count=count+1
                break
    if count==5:
        pass_=1
    else:
        pass_=0  

    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        count=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["root_bridge_id_prior"]==61440 and frames["bridge_id_prior"]==61440 and count==0:
                    count=count+1    
                if frames["root_bridge_id_prior"]==40960 and frames["bridge_id_prior"]==40960 and count==1:
                    count=count+1 
                if frames["root_bridge_id_prior"]==24576 and frames["bridge_id_prior"]==24576 and count==2:
                    count=count+1 
                if frames["root_bridge_id_prior"]==12288 and frames["bridge_id_prior"]==12288 and count==3:
                    count=count+1 
                if frames["root_bridge_id_prior"]==0 and frames["bridge_id_prior"]==0 and count==4:
                    count=count+1
                    break
        if count==5:
            pass_=1
        else:
            pass_=0  

    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        count=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["root_bridge_id_prior"]==61440 and frames["bridge_id_prior"]==61440 and count==0:
                    count=count+1    
                if frames["root_bridge_id_prior"]==40960 and frames["bridge_id_prior"]==40960 and count==1:
                    count=count+1 
                if frames["root_bridge_id_prior"]==24576 and frames["bridge_id_prior"]==24576 and count==2:
                    count=count+1 
                if frames["root_bridge_id_prior"]==12288 and frames["bridge_id_prior"]==12288 and count==3:
                    count=count+1 
                if frames["root_bridge_id_prior"]==0 and frames["bridge_id_prior"]==0 and count==4:
                    count=count+1
                    break
        if count==5:
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

def test_mstp_8_6_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    count=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        if frame_mstp==1:
            if (frames["root_bridge_id_prior"]!=0 and frames["root_bridge_id_prior"]!=4096 and frames["bridge_id_prior"]!=32768 )or frames["root_bridge_id"]!=bridge_id :
                pass_=0
                break
        now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()        
def test_mstp_9_1_verifier(test):
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
    esta=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        
        if frame_mstp==1:
            root_port= bool(int(frames["CIST_flags"],16)&0b00001000)
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa":
                root_id=frames["root_bridge_id"]
                esta=1
            if frames["mac_src"]!="aa:aa:aa:aa:aa:aa" and esta==1 and root_port==True:
                pass_=1
                break
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        pass_=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["root_bridge_id"]==root_id:
                    pass_=1
                    break
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        pass_=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["root_bridge_id"]==root_id:
                    pass_=1
                    break





           
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_9_2_verifier(test):
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
    count=0
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        
        if frame_mstp==1:
            if frames["port_id"]=="0001" and count==0:
                count=count+1
            if frames["port_id"]=="6001" and count==1:
                count=count+1
            if frames["port_id"]=="a001" and count==2:
                count=count+1      
                break
    if count==3:
        pass_=1
    else:
        pass_=0

    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        pass_=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["port_id"]=="2001" and count==0:
                    count=count+1
                if frames["port_id"]=="7001" and count==1:
                    count=count+1
                if frames["port_id"]=="d001" and count==2:
                    count=count+1      
                    break
        if count==3:
            pass_=1
        else:
            pass_=0
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        pass_=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["port_id"]=="5001" and count==0:
                    count=count+1
                if frames["port_id"]=="9001" and count==1:
                    count=count+1
                if frames["port_id"]=="f001" and count==2:
                    count=count+1      
                    break
        if count==3:
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

def test_mstp_9_3_verifier(test):
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
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        
        if frame_mstp==1:
            if frames["port_id"]!="a001" and frames["port_id"]!="1001" and frames["port_id"]!="8001":
                pass_=0
                break
  

    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        pass_=1
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["port_id"]!="d001" and frames["port_id"]!="8001" and frames["port_id"]!="1001":
                    pass_=0
                    break
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        pass_=1
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["port_id"]!="f001" and frames["port_id"]!="1001" and frames["port_id"]!="8001":
                    pass_=0
                    break
    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_10_1_verifier(test):
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
    esta=0
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        
        if frame_mstp==1:
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa":
                root_id=frames["root_bridge_id"]    
                
                break


    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        
        if frame_mstp==1:
            if frames["message_age"]==0 and frames["root_bridge_id"]==root_id and esta==0:
                esta=1
            if frames["message_age"]==18 and frames["root_bridge_id"]==root_id and esta==1:
                pass_=1
                break

    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        esta=0
        pass_=0
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["message_age"]==0 and frames["root_bridge_id"]==root_id and esta==0:
                    esta=1
                if frames["message_age"]==18 and frames["root_bridge_id"]==root_id and esta==1:
                    pass_=1
                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_10_2_verifier(test):
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
    esta=0
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        
        if frame_mstp==1:
            if frames["mac_src"]=="aa:aa:aa:aa:aa:aa":
                root_id=frames["root_bridge_id"]    
                
                break


    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        
        if frame_mstp==1:
            if frames["message_age"]==18 and frames["root_bridge_id"]==root_id:
                
                pass_=1
                break
    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["message_age"]==18 and frames["root_bridge_id"]==root_id:
                    pass_=1
                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_10_3_verifier(test):
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
    esta=0
    array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
    for i in array_pkts_IF1:
        frame_mstp=obtener_mstp(i)
        
        if frame_mstp==1:
            if frames["mac_src"]!="aa:aa:aa:aa:aa:aa" and frames["message_age"]!=0:
                  pass_=0
                  break
 

    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["message_age"]!=0 and frames["root_bridge_id"]==bridge_id:
                    
                    pass_=0
                    break
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["message_age"]!=0 and frames["root_bridge_id"]==bridge_id:
                    
                    pass_=0
                    break

    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["message_age"]!=0 and frames["root_bridge_id"]==bridge_id:
                    
                    pass_=0
                    break

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_10_4_verifier(test):
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
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["message_age"]!=0 and frames["root_bridge_id"]==bridge_id:
                    
                    pass_=0
                    break
    if pass_==1:
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["message_age"]!=0 and frames["root_bridge_id"]==bridge_id:
                    
                    pass_=0
                    break



    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_11_1_verifier(test):
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
        pass_=0
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["max_age"]==6 and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==0:
                    esta=1
                if frames["max_age"]==7 and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==1:
                    pass_=1

    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
        pass_=0
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["max_age"]==6 and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==0:
                    esta=1
                if frames["max_age"]==7 and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==1:
                    pass_=1

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_11_2_verifier(test):
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
        pass_=0
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["max_age"]==5 and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==0:
                    esta=1
                if frames["max_age"]==0 and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==1:
                    pass_=1

    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
        pass_=0
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["max_age"]==5 and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==0:
                    esta=1
                if frames["max_age"]==0 and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==1:
                    pass_=1

    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_11_3_verifier(test):
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
        
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                if frames["max_age"]!=20:
                    pass_=0

    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            if frame_mstp==1:
                 if frames["max_age"]!=20:
                    pass_=0


    now = datetime.now()

    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    if pass_!=0 :
        f.write("PASS\r"+current_time)
    else: 
        f.write("Fail\r"+current_time)
              
    f.close()

def test_mstp_12_1_verifier(test):
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
       
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                topo_change= bool(int(frames["CIST_flags"],16)&0b00000001)
                if frames["hello_time"]!=2:
                    pass_=0
                if topo_change!=True:
                    
                    
                    if esta==1:
                        delta=i.time-anterior
                        if delta>2.2 or delta<1.8:
                            pass_=0
                    anterior=i.time
                    if esta==0:
                        esta=1

               
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()
    
def test_mstp_12_2_verifier(test):
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
       
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                
                if frames["hello_time"]!=2 or frames["hello_time"]!=3 or frames["hello_time"]!=10:
                    pass_=0
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()               

def test_mstp_12_3_verifier(test):
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
       
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                topo_change= bool(int(frames["CIST_flags"],16)&0b00000001)
                if frames["hello_time"]!=2:
                    pass_=0
                    if esta==1:
                        delta=i.time-anterior
                        if delta>2.2:
                            pass_=0
                    anterior=i.time
                    if esta==0:
                        esta=1

               
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()
   
def test_mstp_13_1_verifier(test):
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
       
        esta=0
        cont=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["fwd_delay"]==4 and frames["mac_src"]!="aa:aa:aa:aa:aa:aa" and cont==0:
                    cont=cont+1
                if frames["fwd_delay"]==30 and frames["mac_src"]!="aa:aa:aa:aa:aa:aa" and cont==1:
                    cont=cont+1
                
        if cont==2:
            pass_=1
        else:
            pass_=0


    if pass_==1:
       
        esta=0
        cont=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["fwd_delay"]==4 and frames["mac_src"]!="aa:aa:aa:aa:aa:aa" and cont==0:
                    cont=cont+1
                if frames["fwd_delay"]==30 and frames["mac_src"]!="aa:aa:aa:aa:aa:aa" and cont==1:
                    cont=cont+1
               
        if cont==2:
            pass_=1
        else:
            pass_=0



    if pass_==1:
       
        esta=0
        cont=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["fwd_delay"]==4 and frames["mac_src"]!="aa:aa:aa:aa:aa:aa" and cont==0:
                    cont=cont+1
                if frames["fwd_delay"]==30 and frames["mac_src"]!="aa:aa:aa:aa:aa:aa" and cont==1:
                    cont=cont+1
                
        if cont==2:
            pass_=1
        else:
            pass_=0               
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()
   
def test_mstp_13_2_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa":
                    fwd_delay=frames["fwd_delay"]
              


    if pass_==1:
       
        pass_==0
        esta=0
        cont=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if  frames["mac_src"]=="bb:bb:bb:bb:bb:bb" and esta==0:
                    esta=1
                if frames["fwd_delay"]==fwd_delay and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==1:
                   pass_=1
               


    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
        pass_==0
        esta=0
        cont=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if  frames["mac_src"]=="bb:bb:bb:bb:bb:bb" and esta==0:
                    esta=1
                if frames["fwd_delay"]==fwd_delay and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==1:
                   pass_=1
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_13_3_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa":
                    fwd_delay=frames["fwd_delay"]
              


    if pass_==1:
       
        pass_==0
        esta=0
        cont=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if  frames["mac_src"]=="bb:bb:bb:bb:bb:bb" and esta==0:
                    esta=1
                if frames["fwd_delay"]==fwd_delay and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==1:
                   pass_=1
               


    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
        pass_==0
        esta=0
        cont=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if  frames["mac_src"]=="bb:bb:bb:bb:bb:bb" and esta==0:
                    esta=1
                if frames["fwd_delay"]==fwd_delay and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" and esta==1:
                   pass_=1
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_13_4_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["fwd_delay"]!=4 :
                   pass_=0
                    
              


    if pass_==1:
       
       
        esta=0
        cont=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                
                if frames["fwd_delay"]!=4 :
                   pass_=0
               


    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
        
        esta=0
        cont=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["fwd_delay"]!=4 :
                   pass_=0
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_14_1_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" :
                   root_id=frames["root_bridge_id"]
                   max_age=frames["max_age"]
                   fwd_delay=frames["fwd_delay"]
                   break
    if pass_==1:
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if root_id==frames["root_bridge_id"] and max_age==frames["max_age"] and  fwd_delay==frames["fwd_delay"] and frames["hello_time"]==2:
                   pass_=1
                   break    
                    
              

    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
        
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if root_id==frames["root_bridge_id"] and max_age==frames["max_age"] and  fwd_delay==frames["fwd_delay"] and frames["hello_time"]==2:
                    pass_=1
                    break 
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_15_1_verifier(test):
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
       
        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["length"]=="00" and (frames["type"]=="89" or frames["type"]=="69") :
                   pass_=1
                else:
                    pass_=0
                    break
    
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()
def test_mstp_15_2_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" :
                   root_id=frames["root_bridge_id"]
                   
                   break
    if pass_==1:
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if root_id==frames["root_bridge_id"]:
                   pass_=1
                   break  
    
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_16_1_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" :
                   root_id=frames["root_bridge_id"]
                
        if pass_==1:
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if root_id==frames["root_bridge_id"] :
                        pass_=1
                    
        if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if root_id==frames["root_bridge_id"] :
                        pass_=1            
                
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_16_2_verifier(test):
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
       
        pass_=0
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                
               
                    if regional_root==frames["root_bridge_id"] and frames["mac_src"]!="aa:aa:aa:aa:aa:aa"  :
                        pass_=1
                
        if pass_==1:
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if regional_root==frames["root_bridge_id"] :
                        pass_=1

        if pass_==1:
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if regional_root==frames["root_bridge_id"] :
                        pass_=1

        if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if regional_root==frames["root_bridge_id"] :
                        pass_=1            
                
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_17_1_verifier(test):
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
       
        pass_=0
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                   int_root_path_cost=frames["CIST_int_path_cost"]
                   ext_path_cost=frames["CIST_ext_path_cost"] 
                   
                   esta=1
                   
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==1 and int_root_path_cost!=frames["CIST_int_path_cost"]:
                   int_root_path_cost2=frames["CIST_int_path_cost"]
                   ext_path_cost2=frames["CIST_ext_path_cost"] 
                   pass_=1
                   esta=2
                   break

                
        if pass_==1:
            esta=0
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if int_root_path_cost+200000==frames["CIST_int_path_cost"] and esta==0 :
                        esta=1
                    if int_root_path_cost2+200000==frames["CIST_int_path_cost"] and esta==1 :
                        pass_=1
                        break

      

        if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
            esta=0
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if ext_path_cost==frames["CIST_ext_path_cost"] and esta==0 :
                        esta=1   
                    if ext_path_cost2==frames["CIST_ext_path_cost"] and esta==1 :
                        pass_=1 
                        break        
                
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_17_3_verifier(test):
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
       
        pass_=0
        esta=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==0:
                   int_root_path_cost=frames["CIST_int_path_cost"]
                   ext_path_cost=frames["CIST_ext_path_cost"]
                   root_id=frames["root_bridge_id"] 
                   
                   esta=1
                   
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==1 and int_root_path_cost!=frames["CIST_int_path_cost"]:
                   int_root_path_cost2=frames["CIST_int_path_cost"]
                   ext_path_cost2=frames["CIST_ext_path_cost"] 
                   root_id2=frames["root_bridge_id"]
                   esta=2
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" and esta==2 and int_root_path_cost!=frames["CIST_int_path_cost"] and int_root_path_cost2!=frames["CIST_int_path_cost"]:
                   int_root_path_cost3=frames["CIST_int_path_cost"]
                   ext_path_cost3=frames["CIST_ext_path_cost"] 
                   root_id3=frames["root_bridge_id"]
                   pass_=1
                   break
                  

                
        if pass_==1:
            esta=0
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if frames["CIST_int_path_cost"]==0 and frames["root_bridge_id"]==root_id :
                        pass_=1
                    

        if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
            esta=0
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if ext_path_cost+200000==frames["CIST_ext_path_cost"] and esta==0 :
                        esta=1   
                    if ext_path_cost2+200000==frames["CIST_ext_path_cost"] and esta==1 :
                        esta=2
                    if ext_path_cost3+200000==frames["CIST_ext_path_cost"] and esta==2 :
                        pass_=1
                        break        
                
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_18_1_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" :
                   root_id=frames["root_bridge_id"]
                
        if pass_==1:
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if root_id==frames["root_bridge_id"] :
                        pass_=1
                    
        if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if root_id==frames["root_bridge_id"] :
                        pass_=1            
                
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_18_2_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" :
                   root_id=frames["root_bridge_id"]
                
        if pass_==1:
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if root_id==frames["root_bridge_id"] :
                        pass_=1
                    
        if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if root_id==frames["root_bridge_id"] :
                        pass_=1            
                
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_18_3_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" :
                   root_id=frames["root_bridge_id"]
                
        if pass_==1:
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if root_id==frames["root_bridge_id"] :
                        pass_=1
                    
        if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
            pass_=0
            array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
            for i in array_pkts_IF1:
                frame_mstp=obtener_mstp(i)
                
                if frame_mstp==1:
                    if root_id==frames["root_bridge_id"] :
                        pass_=1            
                
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_19_1_verifier(test):
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
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_regional_root"][0]==bridge_id  and frames["mac_src"]!="aa:aa:aa:aa:aa:aa":
                    pass_=1
                    break
                
       
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_19_2_verifier(test):
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
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]=="aa:aa:aa:aa:aa:aa" :
                   root_id=frames["root_bridge_id"]
                   pass_=1
                
    if pass_==1:
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]!="bb:bb:bb:bb:bb:bb":
                    if frames["mstd_regional_root"][0]==root_id :
                        pass_=1
                        break       
    
                          
    if pass_==1:
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_prior"][0]=="6001" :
                    pass_=1
                    break                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_19_3_verifier(test):
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
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_regional_root"][0]==bridge_id  and frames["mac_src"]!="aa:aa:aa:aa:aa:aa":
                    pass_=1
                    break
                
       
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_20_1_verifier(test):
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
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_bridge_id_prior"][0]==9 and frames["mstd_bridge_id_prior"][1]==10 and frames["mac_src"]!="aa:aa:aa:aa:aa:aa" :
                    pass_=1
                    break
                
       
    
                          
                             
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_20_2_verifier(test):
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
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF1.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_bridge_id_prior"][0]==9 and frames["mstd_prior"][0]=="6001" and frames["mac_src"]!="aa:aa:aa:aa:aa:aa" :
                    pass_=1
                    break
                
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_21_1_verifier(test):
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
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_int_path_cost"][0]==400000  and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" :
                    pass_=1
                    break
    if pass_==1:
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_int_path_cost"][0]==400000  and frames["mac_src"]!="bb:bb:bb:bb:bb:bb" :
                    pass_=1
                    break                
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_22_1_verifier(test):
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
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_reamining_hops"][0]==18 and frames["mstd_reamining_hops"][1]==1:
                    pass_=1
                    break
    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_reamining_hops"][0]==18 and frames["mstd_reamining_hops"][1]==1:
                    pass_=1
                    break                
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_22_2_verifier(test):
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
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mac_src"]!="bb:bb:bb:bb:bb:bb":
                    if frames["mstd_reamining_hops"][0]==20 and frames["mstd_regional_root"][0]==regional_root:
                        pass_=1
                        break
    if pass_==1:
       
        pass_=0
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
                if frames["mstd_reamining_hops"][0]==20 and frames["mstd_regional_root"][0]==regional_root:
                    pass_=1
                    break                
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

def test_mstp_23_1_verifier(test):
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
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
               if frames["type"]!="89" and frames["type"]!="69":
                   pass_=0
                   break 

    if pass_==1:
       
        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF2.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
               if frames["type"]!="89" and frames["type"]!="69":
                   pass_=0
                   break 

    if pass_==1:
       
        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF3.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
               if frames["type"]!="89" and frames["type"]!="69":
                   pass_=0
                   break 

    if pass_==1 and  os.path.exists(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap"):
       
        
        array_pkts_IF1=rdpcap(debug_path+"VERIFIER/Report/"+data["model"]+"/"+config_type+"/"+func+"/"+test+"/"+test+"_captured_IF4.pcap") 
        for i in array_pkts_IF1:
            frame_mstp=obtener_mstp(i)
            
            if frame_mstp==1:
               if frames["type"]!="89" and frames["type"]!="69":
                   pass_=0
                   break                
                       
    if pass_==1:
            f.write("PASS")
    else:
        f.write("FAIL")
        f.close()

"""
test="test_mstp_9_2"
config_type="soce_cli"
func="mstp"

"""
test=sys.argv[1]
config_type=sys.argv[2]
func=sys.argv[3]

os.system("./bash_functions/soce_bash_functions.sh")
#filejson="/home/lab01/sw_develop/SOCE_TEST_24112021/soce_test/DUT_CONFIG_WEB/constants.json"
filejson=debug_path+"DUT_CONFIG_WEB/constants.json"
with open(filejson) as f:
    data = json.loads(f.read())
locals()[test+"_verifier"](test)
