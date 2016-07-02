#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

CFILES = \
	get_networks.c \
	get_protocols.c \
	get_services.c \
	getnetbyname.c \
	getnetbynumber.c \
	getprotobyname.c \
	getprotobynumber.c \
	getservbyname.c \
	getservbyport.c \
	getservprotobyname.c \
	getservprotobyport.c \
	getxxbyname.c \
	getxxbyport.c 

AFILES  = $(CFILES:.c=.asm)
OBJECTS = $(CFILES:.c=.o)

all: net

net: $(OBJECTS)
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/net @zsock_list
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/netdev @zsockdev_list

.c.o:
	zcc +z88 $(CFLAGS) $*.c 

clean:
	$(RM) *.obj *.sym *.map *.o* *.i zcc_opt.def $(AFILES)
