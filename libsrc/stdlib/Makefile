#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.24 2016-07-02 14:44:33 dom Exp $

include ../Make.config

TARGET ?= test
GENOBJECTS = unbcd.o wcmatch.o getopt.o
CUSTOBJECTS = sleep.o csleep.o delay.o

.PHONY: deps

all: deps $(GENOBJECTS) $(CUSTOBJECTS)

%.o: %.c
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

deps:
	$(RM) $(CUSTOBJECTS)

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i 
