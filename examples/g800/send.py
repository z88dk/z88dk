#!/usr/bin/env python
#coding: utf-8

COM_DEVICE='/dev/cu.usbserial-A62WWHTM' # OSX example
#COM_DEVICE='COM3'                      # Windows example
#COM_DEVICE='/dev/ttyS0'                # linux example

import serial
from serial import *
from intelhex import IntelHex
import io as StringIO#python3
#import StringIO #python2
from time import sleep
import sys
import os

def puts(f,ch):
    f.write(ch)
    f.flush()

def send(filename, device, delay=50):

    suffix=os.path.splitext(filename)[-1]

    f=serial.Serial(port=device,
                    baudrate=9600,
                    bytesize=EIGHTBITS,
                    parity=PARITY_NONE,
                    stopbits=STOPBITS_ONE,
                    timeout=None,
                    xonxoff=False,
                    rtscts=True,
                    write_timeout=None, dsrdtr=False, inter_byte_timeout=None)

    dat=[]
    if suffix==".ihx":
        app = IntelHex()
        app.loadhex(filename)
        sio = StringIO.StringIO()
        app[0x100::].write_hex_file(sio)
        dat=sio.getvalue().split('\n')

        maxaddr = app.maxaddr()
        print()
        print("Target: %s"% filename)
        print()
        print("Type your pocket-computer:")
        print()
        print(">MON")
        print("*USER%04X"%maxaddr)
        print("*R")
        print()
        print("please hit enter when you are ready.")
        input()

    elif suffix==".txt":
        print()
        print("Target: %s"% filename)
        print()
        dat=open(filename).readlines().split('\n')
        print("please hit enter when you are ready.")
        input()

    else:
        print("cannot transfer %s file. use ihx or txt" % suffix)
        exit()

    print("Sending...")

    f.reset_output_buffer()

    for line in dat:
        if len(line)==0:
            break
        if line[-1]=='\n':
            line=line[:-1]

        for x in line:
            puts(f,x.encode())
        puts(f,b'\r\n') # CR LF

        #print(line+"\r\n", end="")
        sleep(0.001*delay)

    puts(f,b'\x1a') # End of File
    f.flush()
    f.close()

if __name__ == '__main__':
    delay = 50 #[msec/line]

    if len(sys.argv)!=2:
        print("Usage: python send.py filename")
        quit()

    filename=sys.argv[1]
    send(filename, COM_DEVICE)

