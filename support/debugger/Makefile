all: client_debug getmypid hello.bin source.sh dbgbin

client_debug: client_debug.c mysock.c mysock.h
	gcc -o client_debug client_debug.c mysock.c

getmypid:
	gcc -o getmypid getmypid.c

# Here we turn off optimization, -O0
# We could turn it on for all files which we do not debug (i.e. debugger.c)
#
source.sh: hello.c debugger.c debugger_test.c
	echo "zcc +test -I../../test/machine -m -O0 -o hello.bin debugger_test.c debugger.c hello.c -lndos" > source.sh

hello.bin: source.sh
	sh source.sh

dbgbin:
	gcc -g -I../../test/machine -o dbgbin -DZ88DK -DJUMPZ80  -DDEBUG -DLSB_FIRST dbgbin.c debugtarget_test.c ../../test/machine/Z80/Z80.o ../../test/machine/Z80/Debug.o mysock.c


clean:
	rm -f client_debug getmypid hello.bin a.bin source.sh dbg_hello.* sourcedbg.sh tmp.bin zcc_opt.def hello.map *.exe variable*.opt *.o varsrc.txt a.bin a.bas dbgbin *~
