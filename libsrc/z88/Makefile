#
# Wahey, a messed up makefile for building libraries!
#


all: blah z88

blah:
	cd fdstdio ; make

z88:
	zcc -vn -make-lib RegisterInt.c
	zcc -vn -make-lib DeRegisterInt.c
	zcc -vn -make-lib QueryPackage.c
	zcc -vn -make-lib getpid.c
	zcc -vn -make-lib nameapp.c
	zcc -vn -make-lib wcopen.c
	zcc -vn -make-lib wcnext.c
	zcc -vn -make-lib wcclose.c
	zcc -vn -make-lib exec_cli.c
	zcc -vn -make-lib stripdev.c
	zcc -vn -make-lib strippath.c
	zcc -vn -make-lib openpopup.c
	zcc -vn -make-lib openwindow.c
	zcc -vn -make-lib opentitled.c
	z80asm -d -ns -nm -Mo -x../z88 @z88list


clean:
	rm -f *.obj *.sym *.map *.o *~ zcc_opt.def
