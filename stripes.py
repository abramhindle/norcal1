# coding=utf8
import sys
import cv2
import numpy as np
from numpy import *
# import freenect
import liblo
import random
import time
import logging
import scipy.ndimage.morphology
import argparse


logging.basicConfig(stream = sys.stderr, level=logging.INFO)
# 1. get kinect input
# 2. bounding box calculation

parser = argparse.ArgumentParser(description='Track Motion!')
parser.add_argument('-c', dest='c', default=0,help="Web Cam number")
parser.add_argument('-osc', dest='osc', default=7770,help="OSC Port")
parser.set_defaults(motion=False,osc=7770)
args = parser.parse_args()
target = liblo.Address(args.osc)

def send_osc(path,*args):
    global target
    return liblo.send(target, path, *args)

def current_time():
    return int(round(time.time() * 1000))

screen_name = "Main"
fullscreen = False
cv2.namedWindow(screen_name, cv2.WND_PROP_FULLSCREEN)

cap = None
cap = cv2.VideoCapture(int(args.c))
ohori = None
overti = None
while(1):
    ret, frame = cap.read()
    if not ret:
        continue
    grey = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)




    cv2.imshow(screen_name,frame)
    horiz = cv2.resize(grey, (16, 1)) 
    vert  = cv2.resize(grey, (1,16))
    verti = (vert/(10000.0*255.0))[:,0].tolist()
    hori = (horiz/(10000.0*255.0))[0,:].tolist()    
    if (ohori == None):
        ohori = hori
        overti = verti
    outi = [8,7,9,6,10,5,11,4,12,3,13,2,14,1,15,0]
    outi.reverse()
    out = []
    for i in outi:
        if i % 2 == 0:
            out.append(float(abs(verti[i]-overti[i])))
        else:
            out.append(float(abs(hori[i]-ohori[i])))
    ohori = hori
    overti = overti
    liblo.send(target, "/fft/sbins", *out)

    cv2.imshow("horiz",cv2.resize(horiz,(256,256)))
    cv2.imshow("vert",cv2.resize(vert,(256,256)))
    if cv2.waitKey(1) & 0xFF == 27:
        break
