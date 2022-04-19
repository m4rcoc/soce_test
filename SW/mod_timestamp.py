#!usr/bin/python3.10
# -*- coding: utf-8 -*-

from scapy.all import *
import sys
import os
import struct
import re
import random
import threading
import time
from uuid import getnode
import json
import string
import threading
from datetime import datetime
from scapy.config import conf        
        

if __name__ == '__main__':        
        
    pkts = rdpcap(sys.argv[1])
    cooked=[]
    timestamp = 1
    for p in pkts:
        p.time = timestamp
        timestamp += 0.5
        pmod=p
        cooked.append(pmod)
    wrpcap(sys.argv[1], cooked)