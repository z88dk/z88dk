#
# Wahey, a messed up makefile for building libraries!
#


all: 
	z80asm -d -ns -nm -Mo -x../adt @adt.lst

clean:
	cd hashtable ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
	cd heap ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
	cd linkedlist ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
	cd stack ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
	cd queue ; $(RM) *.o* *.sym *.map zcc_opt.def ; cd ..
