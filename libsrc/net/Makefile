#
# Wahey, a messed up makefile for building libraries!
#

CFILES = \
	get_networks.c \
	get_protocols.c \
	get_services.c \
	getxxbyname.c \
	getxxbyport.c 

ACFILES = \
	getnetbyname.c \
	getnetbynumber.c \
	getprotobyname.c \
	getprotobynumber.c \
	getservbyname.c \
	getservbyport.c \
	getservprotobyname.c \
	getservprotobyport.c

OBJECTS = $(CFILES:.c=.o) $(ACFILES:.c=.o)

all: net

net: $(OBJECTS)
	z80asm -d -ns -nm -Mo -x../net @zsock_list
	z80asm -d -ns -nm -Mo -x../netdev @zsockdev_list

.c.o:
	zcc -vn -Wn43 -make-lib $*.c 

clean:
	rm -f *.obj *.sym *.map *.o* *.i zcc_opt.def $(CFILES:.c=.asm)  $(ACFILES:.c=.asm)
