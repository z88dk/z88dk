#
# Ah, that'd be nice, a library makefile!
#


all:	genlibs z88libs tilibs zxlibs \
	nc_clib.lib vz_clib.lib vzansi_clib.lib cpm_clib.lib \
	mz_clib.lib mzansi_clib.lib zx81_clib.lib zx81ansi_clib.lib \
	abc80_clib.lib aceansi_clib.lib

genlibs: m.lib malloc.lib z80_crt0.lib

z88libs: mz.lib z88.lib z88_clib.lib net.lib z88net_clib.lib farz88.lib

tilibs: ti82ansi_clib.lib ti83ansi_clib.lib ti83pansi_clib.lib \
	ti85ansi_clib.lib ti86ansi_clib.lib

zxlibs: zx_clib.lib zxan_clib.lib


# Garry's z88 far library
farz88.lib:
	cd farz88 ; make

# Generic maths build
m.lib:
	cd genmath; make

# Z88 maths build

mz.lib:
	cd z88math; make

# Graphics library (for both app and basic - diff libs though!)

gfx.lib:
	cd graphics ; make

malloc.lib:
	cd malloc ; make

# Startup code (such as division etc) common to all z80s

z80_crt0.lib:
	cd z80_crt0s ; make

# Custom z88 routines for application

z88.lib:
	cd z88 ; make

# ZSock API (wrappers to package calls)

net.lib:
	cd net ; make

# The heavy beast, contains all the other routines

z88_clib.lib:
	cd fcntl ; make lz88
	cd stdio ; make lz88
	cd stdlib ; make lz88
	cd strings ; make 
	cd printflike ; make 
	cd time ; make lz88
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xz88_clib @z88.lst

# Network stdio

z88net_clib.lib:
	cd fcntl ; make lz88
	cd stdio ; make lz88net
	cd stdlib ; make lz88
	cd strings ; make 
	cd printflike ; make 
	cd time ; make lz88
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xz88net_clib @z88net.lst

# 64/32 column library for ZX Spectrum

zx_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	cd time ; make lzx
	z80asm -d -ns -nm -Mo -DFORzx -xzx_clib @zx.lst

# vt100 C lib for spectrum
zxan_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	cd time ; make lzx
	z80asm -d -ns -nm -Mo -DFORzx -xzxan_clib @zxansi.lst

# Untested C lib for NC100 machinens

nc_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xnc_clib @nc100.lst

# VZ200 lib from Stefano

vz_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xvz_clib @vz200.lst

# VZ200 ansi lib from Stefano

vzansi_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xvzansi_clib @vzansi.lst

# zx81 lib from Stefano

zx81_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -DFORzx81 -xzx81_clib @zx81.lst

# zx81 ansi lib from Stefano

zx81ansi_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xzx81ansi_clib @zx81ansi.lst

# Texas Instrument's calculators:
# almost the same lib code with different -D flag set

ti82_clib.lib:
	./tideps.sh
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -DFORti82 -xti82_clib @ti82.lst

ti82ansi_clib.lib:
	./tideps.sh
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -DFORti82 -xti82ansi_clib @ticansi.lst

ti83ansi_clib.lib:
	./tideps.sh
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -DFORti83 -xti83ansi_clib @ticansi.lst

ti83pansi_clib.lib:
	./tideps.sh
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -DFORti83p -xti83pansi_clib @ticansi.lst

ti85ansi_clib.lib:
	./tideps.sh
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -DFORti85 -xti85ansi_clib @ticansi.lst

ti86ansi_clib.lib:
	./tideps.sh
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -DFORti86 -xti86ansi_clib @ticansi.lst

# cpm lib from Stefano

cpm_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xcpm_clib @cpm.lst

# Sharp MZ lib from Stefano

mz_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xmz_clib @mz.lst

# Sharp MZ ansi lib from Stefano

mzansi_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xmzansi_clib @mzansi.lst

# ABC80 ANSI library - from Stefano
abc80_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xabc80_clib @abc80.lst

# Jupiter ACE library - stefano
aceansi_clib.lib:
	cd strings ; make
	cd stdlib ; make gen
	cd stdio ; make generic
	cd printflike ; make 
	cd setjmp ; make 
	cd assert ; make 
	z80asm -d -ns -nm -Mo -xaceansi_clib.lib @aceansi.lst



clean:
	cd strings ; make clean
	cd stdlib ; make clean
	cd stdio ; make clean
	cd printflike ; make clean
	cd setjmp ; make clean
	cd assert ; make clean
	rm -f *.lib */*/*.o */*.opt */*/*.obj */*/*.err
	rm -f */*.o */*.sym */*~ */zcc_opt.def */core */*.err

install:
	cp *.lib ../lib/clibs/
