#
# Ah, that'd be nice, a library makefile!
#
# $Id: Makefile,v 1.43 2002-07-15 15:34:06 dom Exp $


all:	genlibs z88libs tilibs zxlibs \
	nc_clib.lib vz_clib.lib vzansi_clib.lib cpm_clib.lib \
	mz_clib.lib mzansi_clib.lib \
	abc80_clib.lib aceansi_clib.lib sam_clib.lib \
	msx_clib.lib svi_clib.lib m5_clib.lib cpc_clib.lib \
	c128ansi_clib.lib aquarius_clib.lib aquansi_clib.lib \
	rex_clib.lib zx81_clib.lib zx81ansi_clib.lib

genlibs: m.lib malloc.lib z80_crt0.lib

z88libs: mz.lib z88.lib z88_clib.lib net.lib z88net_clib.lib farz88.lib \
	 z88ansi_clib.lib gfx.lib 

tilibs: ti82ansi_clib.lib ti82_clib.lib ti83ansi_clib.lib ti83_clib.lib \
	ti83pansi_clib.lib ti83p_clib.lib ti85ansi_clib.lib ti85_clib.lib \
	ti86ansi_clib.lib ti86_clib.lib \
	tigray82.lib tigray83.lib tigray83p.lib tigray85.lib tigray86.lib

zxlibs: zx_clib.lib zxan_clib.lib


# Garry's z88 far library
farz88.lib:
	@echo ''
	@echo '---> Building Z88 Far Malloc Library  <---'
	@echo ''
	cd farz88 ; $(MAKE)

# Generic maths build
m.lib:
	@echo ''
	@echo '---> Building Z80 Generic Maths Library  <---'
	@echo ''
	cd genmath; $(MAKE)

# Z88 maths build

mz.lib:
	@echo ''
	@echo '---> Building Z88 Maths Library  <---'
	@echo ''
	cd z88math; $(MAKE)

# Graphics library (for both app and basic - diff libs though!)

gfx.lib:
	@echo ''
	@echo '---> Building Z88 BASIC gfx Library  <---'
	@echo ''
	./gfxdeps.sh
	z80asm -d -ns -nm -Mo -xgfx -DFORz88 @z88gfx.lst
	./gfxdeps.sh
	z80asm -d -ns -nm -Mo -xgfxapp -DAPPZ88 -DFORz88 @z88gfx.lst

malloc.lib:
	@echo ''
	@echo '---> Building Near Malloc Library  <---'
	@echo ''
	cd malloc ; $(MAKE)

# Startup code (such as division etc) common to all z80s

z80_crt0.lib:
	@echo ''
	@echo '---> Building Z80 crt0 Library  <---'
	@echo ''
	cd z80_crt0s ; $(MAKE)

# Custom z88 routines for application

z88.lib:
	@echo ''
	@echo '---> Building Z88 Custom Library  <---'
	@echo ''
	cd z88 ; $(MAKE)

# ZSock API (wrappers to package calls)

net.lib:
	@echo ''
	@echo '---> Building Z88 ZSock Library  <---'
	@echo ''
	cd net ; $(MAKE)

# The heavy beast, contains all the other routines

z88_clib.lib:
	@echo ''
	@echo '---> Building Z88 Library  <---'
	@echo ''
	cd fcntl ; $(MAKE) lz88
	cd stdio ; $(MAKE) lz88
	cd stdlib ; $(MAKE) lz88
	cd strings ; $(MAKE) 
	cd printflike ; $(MAKE) 
	cd time ; $(MAKE) lz88
	cd rs232 ; $(MAKE) lz88
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -z80-verb -d -ns -nm -Mo -DFORz88 -xz88_clib @z88.lst


z88ansi_clib.lib:
	@echo ''
	@echo '---> Building Z88 ANSI Library  <---'
	@echo ''
	cd fcntl ; $(MAKE) lz88
	cd stdio ; $(MAKE) lz88
	cd stdlib ; $(MAKE) lz88
	cd strings ; $(MAKE) 
	cd printflike ; $(MAKE) 
	cd time ; $(MAKE) lz88
	cd rs232 ; $(MAKE) lz88
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -xz88ansi_clib @z88ansi.lst

# Network stdio

z88net_clib.lib:
	@echo ''
	@echo '---> Building Z88 Network Aware Library  <---'
	@echo ''
	cd fcntl ; $(MAKE) lz88
	cd stdio ; $(MAKE) lz88net
	cd stdlib ; $(MAKE) lz88
	cd strings ; $(MAKE) 
	cd printflike ; $(MAKE) 
	cd time ; $(MAKE) lz88
	cd rs232 ; $(MAKE) lz88
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -xz88net_clib @z88net.lst

# 64/32 column library for ZX Spectrum

zx_clib.lib:
	@echo ''
	@echo '---> Building ZX Spectrum Library  <---'
	@echo ''
	./gfxdeps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) lzx
	cd stdio ; $(MAKE) generic
	cd fcntl ; $(MAKE) lzx
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd time ; $(MAKE) lzx
	cd rs232 ; $(MAKE) lzx
	./gamesdeps.sh
	cd spectrum ; $(MAKE)
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORzx -xzx_clib @zx.lst

# vt100 C lib for spectrum
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes

zxan_clib.lib:
	@echo ''
	@echo '---> Building ZX Spectrum ANSI Library  <---'
	@echo ''
	rm -f stdio/ansi/spectrum/f_ansi_char.o
	./gfxdeps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) lzx
	cd stdio ; $(MAKE) generic
	cd fcntl ; $(MAKE) lzx
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd time ; $(MAKE) lzx
	cd rs232 ; $(MAKE) lzx
	./gamesdeps.sh
	cd spectrum ; $(MAKE)
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORzx -DROMFONT -xzxan_clib @zxansi.lst

# Untested C lib for NC100 machinens

nc_clib.lib:
	@echo ''
	@echo '---> Building Amstrad NC100 Library  <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -xnc_clib @nc100.lst

# VZ200/300 lib - Stefano

vz_clib.lib:
	@echo ''
	@echo '---> Building VZ200/300 Library  <---'
	@echo ''
	./gfxdeps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -DFORvz -xvz_clib @vz200.lst

# VZ200 ansi lib - Stefano

vzansi_clib.lib:
	@echo ''
	@echo '---> Building VZ200/300 ANSI Library  <---'
	@echo ''
	./gfxdeps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -DFORvz -xvzansi_clib @vzansi.lst

# ZX81 lib - Stefano

zx81_clib.lib:
	@echo ''
	@echo '---> Building ZX81 Library  <---'
	@echo ''
	./gfxdeps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -IXIY -d -ns -nm -Mo -DFORzx81 -xzx81_clib @zx81.lst

# ZX81 ansi lib - Stefano

zx81ansi_clib.lib:
	@echo ''
	@echo '---> Building ZX81 ANSI Library  <---'
	@echo ''
	./gfxdeps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -IXIY -d -ns -nm -Mo -DFORzx81 -xzx81ansi_clib @zx81ansi.lst

# Texas Instrument's calculators:
# almost the same lib code with different -D flag set
# that's why we force most of the lib code to be rebuilt (tideps.sh)

ti82ansi_clib.lib:
	@echo ''
	@echo '---> Building TI82 ANSI Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -IXIY -d -ns -nm -Mo -DFORti82 -DPACKEDFONT -xti82ansi_clib @ticansi.lst

ti82_clib.lib:
	@echo ''
	@echo '---> Building TI82 Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORti82 -xti82_clib @ticalc.lst

tigray82.lib:
	@echo ''
	@echo '---> Building TI82 Grey Library  <---'
	@echo ''
	./tideps.sh
	z80asm -d -ns -nm -Mo -DFORti82 -xtigray82 @tigray.lst


ti83ansi_clib.lib:
	@echo ''
	@echo '---> Building TI83 ANSI Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORti83 -DPACKEDFONT -xti83ansi_clib @ticansi.lst

ti83_clib.lib:
	@echo ''
	@echo '---> Building TI83 Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORti83 -xti83_clib @ticalc.lst

tigray83.lib:
	@echo ''
	@echo '---> Building TI83 Grey Library  <---'
	@echo ''
	./tideps.sh
	z80asm -d -ns -nm -Mo -DFORti83 -xtigray83 @tigray.lst

ti83pansi_clib.lib:
	@echo ''
	@echo '---> Building TI83+ ANSI Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORti83p -DPACKEDFONT -xti83pansi_clib @ticansi.lst

ti83p_clib.lib:
	@echo ''
	@echo '---> Building TI83+ Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORti83p -xti83p_clib @ticalc.lst

tigray83p.lib:
	@echo ''
	@echo '---> Building TI83+ Grey Library  <---'
	@echo ''
	./tideps.sh
	z80asm -d -ns -nm -Mo -DFORti83p -xtigray83p @tigray.lst

ti85ansi_clib.lib:
	@echo ''
	@echo '---> Building TI85 ANSI Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORti85 -DPACKEDFONT -xti85ansi_clib @ticansi.lst

ti85_clib.lib:
	@echo ''
	@echo '---> Building TI85 Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORti85 -xti85_clib @ticalc.lst

tigray85.lib:
	@echo ''
	@echo '---> Building TI85 Grey Library  <---'
	@echo ''
	./tideps.sh
	z80asm -d -ns -nm -Mo -DFORti85 -xtigray85 @tigray.lst

ti86ansi_clib.lib:
	@echo ''
	@echo '---> Building TI86 ANSI Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORti86 -DPACKEDFONT -xti86ansi_clib @ticansi.lst

ti86_clib.lib:
	@echo ''
	@echo '---> Building TI86 Library  <---'
	@echo ''
	./tideps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORti86 -xti86_clib @ticalc.lst

tigray86.lib:
	@echo ''
	@echo '---> Building TI86 Grey Library  <---'
	@echo ''
	./tideps.sh
	z80asm -d -ns -nm -Mo -DFORti86 -xtigray86 @tigray.lst

# CPM lib - Stefano
cpm_clib.lib:
	@echo ''
	@echo '---> Building CP/M Library <---'
	@echo ''
	cd fcntl ; $(MAKE) lcpm
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) lcpm
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -xcpm_clib @cpm.lst

# Sharp MZ lib - Stefano
mz_clib.lib:
	@echo ''
	@echo '---> Building Sharp MZ Library <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -xmz_clib @mz.lst

# Sharp MZ ansi lib - Stefano
mzansi_clib.lib: 
	@echo ''
	@echo '---> Building Sharp MZ ANSI Library <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -xmzansi_clib @mzansi.lst

# ABC80 ANSI library - Stefano
abc80_clib.lib:
	@echo ''
	@echo '---> Building ABC80 Library <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -xabc80_clib @abc80.lst

# Jupiter ACE library - Stefano
aceansi_clib.lib:
	@echo ''
	@echo '---> Building Jupiter Ace ANSI Library <---'
	@echo ''
	./gfxdeps.sh
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	./gamesdeps.sh
	cd games ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORjupiter -xaceansi_clib.lib @aceansi.lst

# Mattel Aquarius library - Stefano
aquarius_clib.lib:
	@echo ''
	@echo '---> Building Mattel Aquarius ANSI Library <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	./gamesdeps.sh
	cd games ; $(MAKE)
	./gfxdeps.sh
	z80asm -d -ns -nm -Mo -DFORaquarius -xaquarius_clib.lib @aquarius.lst

# Mattel Aquarius ANSI library - Stefano
aquansi_clib.lib:
	@echo ''
	@echo '---> Building Mattel Aquarius ANSI Library <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	./gamesdeps.sh
	cd games ; $(MAKE)
	./gfxdeps.sh
	z80asm -d -ns -nm -Mo -DFORaquarius -xaquansi_clib.lib @aquansi.lst

# Xircom REX 6000 library - Dominic
rex_clib.lib:
	@echo ''
	@echo '---> Building Xircom Rex Library  <---'
	@echo ''
	cd strings; $(MAKE)
	cd stdlib ; $(MAKE)
	cd setjmp ; $(MAKE)
	cd rex    ; $(MAKE)
	z80asm -d -ns -nm -Mo -DFORrex -xrex_clib.lib @rex6000.lst

# Sam Coupe library - Stefano
sam_clib.lib:
	@echo ''
	@echo '---> Building Sam Coupe Library  <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -DFORsam -xsam_clib @sam.lst

# Spectravideo SVI library - Stefano
svi_clib.lib:
	@echo ''
	@echo '---> Building Spectravideo Library  <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -DFORsvi -xsvi_clib @svi.lst

# MSX1 library - Stefano
msx_clib.lib:
	@echo ''
	@echo '---> Building MSX Library  <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -DFORmsx -xmsx_clib @msx.lst

# SORD M5 library - Stefano
m5_clib.lib:
	@echo ''
	@echo '---> Building SORD M5 Library  <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -DFORm5 -xm5_clib @m5.lst

# Amstrad CPC library - Stefano
cpc_clib.lib:
	@echo ''
	@echo '---> Building Amstrad CPC Library  <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	z80asm -d -ns -nm -Mo -DFORcpc -xcpc_clib @cpc.lst

# Commodore 128 (Z80 mode) library - Stefano
c128ansi_clib.lib:
	@echo ''
	@echo '---> Building Commodore 128 ANSI Library  <---'
	@echo ''
	cd strings ; $(MAKE)
	cd stdlib ; $(MAKE) gen
	cd stdio ; $(MAKE) generic
	cd printflike ; $(MAKE) 
	cd setjmp ; $(MAKE) 
	cd assert ; $(MAKE) 
	./gfxdeps.sh
	z80asm -d -ns -nm -Mo -DFORc128 -xc128ansi_clib @c128ansi.lst

clean:
	cd assert ; $(MAKE) clean
	cd ctype ; $(MAKE) clean
	cd farz88 ; $(MAKE) clean
	cd fcntl ; $(MAKE) clean
	cd genmath ; $(MAKE) clean
	cd graphics ; $(MAKE) clean
	cd malloc ; $(MAKE) clean
	cd net    ; $(MAKE) clean
	cd printflike ; $(MAKE) clean
	cd rex ; $(MAKE) clean
	cd rs232 ; $(MAKE) clean
	cd setjmp ; $(MAKE) clean
	cd spectrum ; $(MAKE) clean
	cd stdio ; $(MAKE) clean
	cd stdlib ; $(MAKE) clean
	cd strings ; $(MAKE) clean
	cd time ; $(MAKE) clean
	cd z80_crt0s; $(MAKE) clean
	cd z88 ; $(MAKE) clean
	cd z88math ; $(MAKE) clean
	rm -f *.lib
	cd games ; $(MAKE) clean

install:
	cp *.lib ../lib/clibs/
