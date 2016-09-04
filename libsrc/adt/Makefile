#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

all: 
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/adt @adt.lst

clean:
#	cd hashtable ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
	cd heap ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
	cd linkedlist ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
	cd stack ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
	cd queue ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
