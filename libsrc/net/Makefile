#
# Wahey, a messed up makefile for building libraries!
#


all: net


net:
	z80asm -d -ns -nm -Mo -x../net @zsock_list
	rm no_zsock.o
	z80asm -d -ns -nm -DmakeDEVLIB -Mo -x../netdev @zsock_list


clean:
	rm -f *.obj *.sym *.map *.o
