#
# Wahey, a messed up makefile for building libraries!
#


all: net


net:	get_networks.o get_services.o get_protocols.c getnetbyname.o \
	getnetbynumber.o  getprotobyname.o getprotobynumber.o \
	getservbyname.o getservbyport.o getservprotobyname.o \
	getservprotobyport.o getxxbyname.o getxxbyport.o
	z80asm -d -ns -nm -Mo -x../net @zsock_list
	z80asm -d -ns -nm -Mo -x../netdev @zsockdev_list

.c.o:
	zcc -vn -Wn43 -make-lib $*.c


clean:
	rm -f *.obj *.sym *.map *.o
