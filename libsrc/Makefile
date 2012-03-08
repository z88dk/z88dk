#
# Ah, that'd be	nice, a	library	makefile!
#
# Problems? Contact the	person to blame(!) above the section
# for the library
#
# $Id: Makefile,v 1.167 2012-03-08 07:16:45 stefano Exp $


include	Make.config

# LIBRARIES not	built by the global list below:
# - SP1	(build depends on customization	and machine target, "make sp1" for options)

all:	genlibs	z88libs	tilibs zxlibs eplibs c128libs cpclibs \
	abc80_clib.lib abc80ansi_clib.lib abc800_clib.lib \
	ace_clib.lib aceansi_clib.lib aquarius_clib.lib aquansi_clib.lib \
	cpm_clib.lib einstein.lib gal_clib.lib m5_clib.lib \
	msx_clib.lib mtx_clib.lib mz_clib.lib mzansi_clib.lib \
	nascom_clib.lib	nasansi_clib.lib newbrain_clib.lib nc_clib.lib \
	osca_clib.lib ozansi_clib.lib	pps_clib.lib ppsansi_clib.lib \
	rex_clib.lib rcmx000_clib.lib sc3000_clib.lib sms_clib.lib \
	svi_clib.lib sam_clib.lib samansi_clib.lib sorcerer_clib.lib \
	trs80_clib.lib vz_clib.lib vzansi_clib.lib x07_clib.lib\
	embedded_clib.lib test_clib.lib	\
	preempt.lib zx81libs

genlibs: debug.lib gen_math.lib	malloc.lib z80_crt0.lib	ndos.lib adt.lib balloc.lib \
	 im2.lib rect.lib algorithm.lib	lib3d.lib x11.lib

c128libs: c128ansi_clib.lib gfx128.lib gfx128hr.lib gfx128hr480.lib 

eplibs: enterprise_clib.lib gfxep.lib gfxephr.lib

cpclibs: cpc_clib.lib cpcansi_clib.lib cpcfs.lib cpc_math.lib

z88libs: z88_math.lib z88.lib z88_clib.lib net.lib z88net_clib.lib farz88.lib \
	 z88ansi_clib.lib gfx.lib 

tilibs:	ti82ansi_clib.lib ti82_clib.lib	ti83ansi_clib.lib ti83_clib.lib	\
	ti83pansi_clib.lib ti83p_clib.lib ti85ansi_clib.lib ti85_clib.lib \
	ti86ansi_clib.lib ti86_clib.lib

zxlibs:	ts2068_clib.lib ts2068an_clib.lib gfx2068hr.lib gfxspectrum.lib zx_clib.lib zxan_clib.lib zxvgs.lib mzx.lib mzx_tiny.lib zxrom.lib zxfcntl zx232

zx81libs: zx81_clib.lib	zx81ansi_clib.lib gfx81.lib gfx81hr64.lib gfx81hr192.lib m81.lib m81_tiny.lib

# moving external shell	scripts	to makefile to make life easy on
# the windows platform devs (ie	Me :-) -- gamesdeps.sh,	gfxdeps.sh, tideps.sh

#  short script	to sort	out games dependencies
gamesdeps:
	$(RM) -f games/*.o

#  short script	to sort	out gfx	dependencies
gfxdeps:
	$(RM) -f graphics/*.o
	$(RM) -f graphics/c128/*.o
	$(RM) -f graphics/ticalc/*.o
	$(RM) -f graphics/gray/*.o
	$(RM) -f graphics/gray/ticalc/*.o
	$(RM) -f graphics/spectrum/*.o
	$(RM) -f graphics/z88/*.o
	$(RM) -f graphics/text/*.o
	$(RM) -f graphics/text6/*.o
	$(RM) -f graphics/x11/*.o

#  short script	to sort	out ticalc dependencies
tideps:
	$(RM) -f stdio/ticalc/*.o
	$(RM) -f stdio/ansi/ticalc/*.o
	$(RM) -f games/*.o
	$(RM) -f games/ticalc/*.o
	$(RM) -f graphics/*.o
	$(RM) -f graphics/ticalc/*.o
	$(RM) -f graphics/gray/*.o
	$(RM) -f graphics/gray/ticalc/*.o

#  short script	to sort	out ticalc dependencies
msxdeps:
	$(RM) -f stdio/msx/*.o
	$(RM) -f games/*.o
	$(RM) -f games/msx/*.o
	$(RM) -f graphics/*.o
	$(RM) -f graphics/msx/*.o
	$(RM) -f graphics/msx/surface/*.o
	$(RM) -f msx/*.o

zx81deps:
	$(RM) -f assert/*.o
	$(RM) -f setjmp/*.o
	$(RM) -f printflike/*.o
	$(RM) -f strings/*.o
	$(RM) -f stdlib/*.o
	$(RM) -f stdio/*.o
	$(RM) -f stdio_new/stream-general/*.o
	$(RM) -f stdio_new/stream-out/stdio_basechar.o
	$(RM) -f stdio_new/stream-general/stdio_atou.o
	$(RM) -f stdio/ansi/zx81/*.o
	$(RM) -f input/spectrum/*.o
	$(RM) -f input/zx81/*.o
	$(RM) -f games/*.o
	$(RM) -f graphics/*.o
	$(RM) -f graphics/zx81/*.o
	$(RM) -f graphics/zx81/hr/*.o
	$(RM) -f graphics/gray/*.o

# interesting algorithms - aralbrec
algorithm.lib:
	@echo ''
	@echo '--- Building Algorithm Library  ---'
	@echo ''
	cd algorithm ; $(MAKE) ; cd ..

# rectangles, intervals	and points - aralbrec
rect.lib:
	@echo ''
	@echo '--- Building Rectangles Library	---'
	@echo ''
	cd rect	; $(MAKE) ; cd ..

# abstract data	types library -	aralbrec
adt.lib:
	@echo ''
	@echo '--- Building Abstract Data Types	Library	 ---'
	@echo ''
	cd adt ; $(MAKE) ; cd ..

# block	memory allocator - aralbrec
balloc.lib:
	@echo ''
	@echo '--- Building Block Memory Allocator Library  ---'
	@echo ''
	cd balloc ; $(MAKE) ; cd ..

# interrupt mode 2 library - aralbrec
im2.lib:
	@echo ''
	@echo '--- Building IM 2 Library  ---'
	@echo ''
	cd im2 ; $(MAKE) ; cd ..

# Garry's z88 far library - garry (probably dom	now)
farz88.lib:
	@echo ''
	@echo '--- Building Z88	Far Malloc Library  ---'
	@echo ''
	cd farz88 ; $(MAKE) ; cd ..

# Generic maths	build -	dom
gen_math.lib:
	@echo ''
	@echo '--- Building Z80	Generic	Maths Library  ---'
	@echo ''
	cd math/genmath; $(MAKE) ; cd ../..

# Z88 maths build - dom
z88_math.lib:
	@echo ''
	@echo '--- Building Z88	Maths Library  ---'
	@echo ''
	cd math/z88math; $(MAKE) ; cd ../..

# Graphics library (for	both app and basic - diff libs though!)	- dom
gfx.lib:
	@echo ''
	@echo '--- Building Z88	BASIC gfx Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/gfx -DFORz88	@$(LISTFILE_DIRECTORY)/z88gfx.lst
	$(MAKE)	gfxdeps
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/gfxapp -DAPPZ88 -DFORz88 @$(LISTFILE_DIRECTORY)/z88gfx.lst

# Fast vector 3D library - stefano
lib3d.lib:
	@echo ''
	@echo '--- Building 3D Library	---'
	@echo ''
	cd lib3d ; $(MAKE) ; cd ..

# Xlib / X11 and tiny GUI portable library - stefano
x11.lib:
	@echo ''
	@echo '--- Building X11	emulation Library  ---'
	@echo ''
	cd graphics ; $(MAKE) lx11 ; cd	..

# simple malloc	library	- dom
# adding multiple heaps	and realloc - aralbrec
malloc.lib:
	@echo ''
	@echo '--- Building Near Malloc	Library	 ---'
	@echo ''
	cd malloc ; $(MAKE) ; cd ..

ndos.lib:
	cd fcntl/dummy ; $(MAKE) ; cd ../..

# Startup code (such as	division etc) common to	all z80s - dom
z80_crt0.lib:
	@echo ''
	@echo '--- Building Z80	crt0 Library  ---'
	@echo ''
	cd z80_crt0s ; $(MAKE) ; cd ..

# Z88DK	DEBUG utilities
debug.lib:
	@echo ''
	@echo '--- Building DEBUG Library  ---'
	@echo ''
	cd debug ; $(MAKE) ; cd	..

# Custom z88 routines for application -	dom
z88.lib:
	@echo ''
	@echo '--- Building Z88	Custom Library	---'
	@echo ''
	cd z88 ; $(MAKE) ; cd ..

# ZSock	API (wrappers to package calls)	- dom
net.lib:
	@echo ''
	@echo '--- Building Z88	ZSock Library  ---'
	@echo ''
	cd net ; $(MAKE) ; cd ..

# z88 library -	dom
z88_clib.lib:
	@echo ''
	@echo '--- Building Z88	Library	 ---'
	@echo ''
	cd fcntl ; $(MAKE) lz88	; cd ..
	cd stdio ; $(MAKE) lz88	; cd ..
	cd stdlib ; $(MAKE) lz88 ; cd ..
	cd strings ; $(MAKE) ; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd time	; $(MAKE) lz88 ; cd ..
	cd rs232 ; $(MAKE) lz88	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lz88	; cd ..
	$(LIBLINKER) -DFORz88 -x$(OUTPUT_DIRECTORY)/z88_clib @$(LISTFILE_DIRECTORY)/z88.lst

# z88 ansi library - dom
z88ansi_clib.lib:
	@echo ''
	@echo '--- Building Z88	ANSI Library  ---'
	@echo ''
	cd fcntl ; $(MAKE) lz88	; cd ..
	cd stdio ; $(MAKE) lz88	; cd ..
	cd stdlib ; $(MAKE) lz88 ; cd ..
	cd strings ; $(MAKE) ; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd time	; $(MAKE) lz88 ; cd ..
	cd rs232 ; $(MAKE) lz88	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/z88ansi_clib	@$(LISTFILE_DIRECTORY)/z88ansi.lst

# Network stdio	- dom
z88net_clib.lib:
	@echo ''
	@echo '--- Building Z88	Network	Aware Library  ---'
	@echo ''
	cd fcntl ; $(MAKE) lz88	; cd ..
	cd stdio ; $(MAKE) lz88net ; cd	..
	cd stdlib ; $(MAKE) lz88 ; cd ..
	cd strings ; $(MAKE) ; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd time	; $(MAKE) lz88 ; cd ..
	cd rs232 ; $(MAKE) lz88	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/z88net_clib @$(LISTFILE_DIRECTORY)/z88net.lst

# ZX Spectrum fcntl - dom/stefano
zxfcntl:
	@echo ''
	@echo '--- Building ZX Spectrum fcntl libraries ---'
	@echo ''
	cd fcntl ; $(MAKE) lzx ; cd ..

# 64/32	column library for ZX Spectrum - dom/stefano
zx_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx	; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time	; $(MAKE) lzx ;	cd ..
	$(MAKE)	gamesdeps
	cd spectrum ; $(MAKE) ;	cd ..
	cd games ; $(MAKE) lzx ; cd ..
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/zx_clib @$(LISTFILE_DIRECTORY)/zx.lst

# vt100	C lib for spectrum - stefano/dom
# use -DROMFONT	for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
zxan_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum ANSI Library ---'
	@echo ''
	$(RM) stdio/ansi/spectrum/f_ansi_char.o
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx	; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time	; $(MAKE) lzx ;	cd ..
	$(MAKE)	gamesdeps
	cd spectrum ; $(MAKE) ;	cd ..
	cd games ; $(MAKE) lzx ; cd ..
	$(LIBLINKER) -DFORzx $(COLDEFS)	-x$(OUTPUT_DIRECTORY)/zxan_clib	@$(LISTFILE_DIRECTORY)/zxansi.lst

# ZX Spectrum RS232 libraries - stefano
zx232:
	cd rs232 ; $(MAKE) lzx ; cd ..

# 64/32	column library for TS2068 - dom/stefano/alvin
ts2068_clib.lib:
	@echo ''
	@echo '--- Building TS2068 (Spectrum clone) Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx	; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time	; $(MAKE) lzx ;	cd ..
	$(MAKE)	gamesdeps
	cd spectrum ; $(MAKE) ;	cd ..
	cd games ; $(MAKE) lzx ; cd ..
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/ts2068_clib @$(LISTFILE_DIRECTORY)/ts2068.lst

# vt100	C lib for TS2068 - stefano/dom
# use -DROMFONT	for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
ts2068an_clib.lib:
	@echo ''
	@echo '--- Building TS2068 (Spectrum clone) ANSI Library  ---'
	@echo ''
	$(RM) stdio/ansi/spectrum/f_ansi_char.o
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx	; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time	; $(MAKE) lzx ;	cd ..
	$(MAKE)	gamesdeps
	cd spectrum ; $(MAKE) ;	cd ..
	cd games ; $(MAKE) lzx ; cd ..
	$(LIBLINKER) -DFORzx -DA80COL -x$(OUTPUT_DIRECTORY)/ts2068an_clib @$(LISTFILE_DIRECTORY)/ts2068an.lst

# TS2068 HRG graphics lib - Stefano
gfx2068hr.lib:
	@echo ''
	@echo '--- Building TS2068 High Resolution Graphics Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	$(LIBLINKER) -DFORgfx2068hr -x$(OUTPUT_DIRECTORY)/gfx2068hr @$(LISTFILE_DIRECTORY)/gfx2068hr.lst

# TS2068 HRG graphics lib - Stefano
gfxspectrum.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Graphics Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/gfxspectrum @$(LISTFILE_DIRECTORY)/gfxspectrum.lst

# ZXROM	- stefano
zxrom.lib:
	@echo ''
	@echo '--- Building ZXROM Library  ---'
	@echo ''
	$(MAKE)	gamesdeps
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/zxrom @$(LISTFILE_DIRECTORY)/zxrom.lst

# ZXVGS	- yarek
zxvgs.lib:
	@echo ''
	@echo '--- Building ZXVGS Library  ---'
	@echo ''
	cd fcntl ; $(MAKE) lzxvgs ; cd ..
	cd zxvgs; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/zxvgs @$(LISTFILE_DIRECTORY)/zxvgs.lst

# ZX Spectrum maths library - Stefano
mzx.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Maths Library ---'
	@echo ''
	cd math/zxmath ; $(MAKE) mzx	; cd ../..

mzx_tiny.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Tiny Maths Library ---'
	@echo ''
	cd math/zxmath ; $(MAKE) mzx_tiny ; cd ../..

# Native for sprinter -	dom
pps_clib.lib:
	@echo ''
	@echo '--- Building Sprinter Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx	; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd fcntl ; $(MAKE) lpps	; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time	; $(MAKE) lpps ; cd ..
	$(MAKE)	gamesdeps
	cd spectrum ; $(MAKE) ; cd ..
	cd games ; $(MAKE) lzx ; cd ..
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/pps_clib @$(LISTFILE_DIRECTORY)/pps.lst

# vt100	for sprinter - dom
ppsansi_clib.lib:
	@echo ''
	@echo '--- Building Sprinter Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx	; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd fcntl ; $(MAKE) lpps	; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time	; $(MAKE) lpps ; cd ..
	$(MAKE)	gamesdeps
	cd spectrum ; $(MAKE) ;	cd ..
	cd games ; $(MAKE) lzx ; cd ..
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/ppsansi_clib	@$(LISTFILE_DIRECTORY)/ppsansi.lst

# VZ200/300 lib	- Stefano
vz_clib.lib:
	@echo ''
	@echo '--- Building VZ200/300 Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lvz ; cd ..
	$(LIBLINKER) -DFORvz -x$(OUTPUT_DIRECTORY)/vz_clib @$(LISTFILE_DIRECTORY)/vz200.lst

# VZ200	ansi lib - Stefano
vzansi_clib.lib:
	@echo ''
	@echo '--- Building VZ200/300 ANSI Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lvz ; cd ..
	$(LIBLINKER) -DFORvz -x$(OUTPUT_DIRECTORY)/vzansi_clib @$(LISTFILE_DIRECTORY)/vzansi.lst

# ZX81 lib - Stefano
zx81_clib.lib:
	@echo ''
	@echo '--- Building ZX81 Library  ---'
	@echo ''
	$(MAKE)	zx81deps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic_iy ;	cd ..
	cd printflike ;	$(MAKE)	generic_iy ; cd ..
	cd setjmp ; $(MAKE) generic_iy ; cd ..
	cd assert ; $(MAKE) generic_iy ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lzx81	; cd ..
	$(LIBLINKER) -IXIY -DFORzx81 -x$(OUTPUT_DIRECTORY)/zx81_clib @$(LISTFILE_DIRECTORY)/zx81.lst
	$(MAKE)	zx81deps

# ZX81 ansi lib	- Stefano
zx81ansi_clib.lib:
	@echo ''
	@echo '--- Building ZX81 ANSI Library  ---'
	@echo ''
	$(MAKE)	zx81deps
	$(RM) stdio/ansi/zx81/f_ansi_char.o
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic_iy ;	cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lzx81	; cd ..
	$(LIBLINKER) -IXIY -DFORzx81 $(COLDEFS)	-x$(OUTPUT_DIRECTORY)/zx81ansi_clib @$(LISTFILE_DIRECTORY)/zx81ansi.lst
	$(MAKE)	zx81deps

# ZX81 std graphics lib	- Stefano
gfx81.lib:
	@echo ''
	@echo '--- Building ZX81 Standard Graphics Library  ---'
	@echo ''
	$(MAKE)	zx81deps
	$(LIBLINKER) -IXIY -DFORzx81 -x$(OUTPUT_DIRECTORY)/gfx81 @$(LISTFILE_DIRECTORY)/gfx81.lst
	$(MAKE)	zx81deps

# ZX81 HR graphics lib - Stefano
gfx81hr64.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (64 rows)  ---'
	@echo ''
	$(MAKE)	zx81deps
	$(LIBLINKER) -IXIY -DFORzx81hr64 -x$(OUTPUT_DIRECTORY)/gfx81hr64 @$(LISTFILE_DIRECTORY)/gfx81hr.lst
	$(MAKE)	zx81deps
	$(LIBLINKER) -IXIY -DFORzx81hr64 -x$(OUTPUT_DIRECTORY)/gfx81arx64 @$(LISTFILE_DIRECTORY)/gfx81arx.lst
	$(MAKE)	zx81deps

gfx81hr192.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (192 rows)  ---'
	@echo ''
	$(MAKE)	zx81deps
	$(LIBLINKER) -IXIY -DFORzx81hr192 -x$(OUTPUT_DIRECTORY)/gfx81hr192 @$(LISTFILE_DIRECTORY)/gfx81hr.lst
	$(MAKE)	zx81deps
	$(LIBLINKER) -IXIY -DFORzx81hr192 -x$(OUTPUT_DIRECTORY)/gfx81arx192 @$(LISTFILE_DIRECTORY)/gfx81arx.lst
	$(MAKE)	zx81deps
	$(LIBLINKER) -IXIY -DFORzx81mt192 -x$(OUTPUT_DIRECTORY)/gfx81mt192 @$(LISTFILE_DIRECTORY)/gfx81mt.lst
	$(MAKE)	zx81deps

# ZX81 maths library - Stefano
m81.lib:
	@echo ''
	@echo '--- Building ZX 81 Maths	Library	---'
	@echo ''
	cd math/zxmath ; $(MAKE) m81	; cd ../..

m81_tiny.lib:
	@echo ''
	@echo '--- Building ZX 81 Tiny Maths Library ---'
	@echo ''
	cd math/zxmath ; $(MAKE) m81_tiny ; cd ../..

# Texas	Instrument's calculators: - stefano/henk
# almost the same lib code with	different -D flag set
# that's why we	force most of the lib code to be rebuilt (tideps.sh)
ti82ansi_clib.lib:
	@echo ''
	@echo '--- Building TI82 ANSI Library  ---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti82 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti82ansi_clib	@$(LISTFILE_DIRECTORY)/ticansi.lst

ti82_clib.lib:
	@echo ''
	@echo '--- Building TI82 Library  ---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti82 -x$(OUTPUT_DIRECTORY)/ti82_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83ansi_clib.lib:
	@echo ''
	@echo '--- Building TI83 ANSI Library  ---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti83 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83ansi_clib	@$(LISTFILE_DIRECTORY)/ticansi.lst

ti83_clib.lib:
	@echo ''
	@echo '--- Building TI83 Library  ---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti83 -x$(OUTPUT_DIRECTORY)/ti83_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83pansi_clib.lib:
	@echo ''
	@echo '--- Building TI83+ ANSI Library	---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti83p	-DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83pansi_clib @$(LISTFILE_DIRECTORY)/ticansi.lst

ti83p_clib.lib:
	@echo ''
	@echo '--- Building TI83+ Library  ---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti83p	-x$(OUTPUT_DIRECTORY)/ti83p_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti85ansi_clib.lib:
	@echo ''
	@echo '--- Building TI85 ANSI Library  ---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti85 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti85ansi_clib	@$(LISTFILE_DIRECTORY)/ticansi.lst

ti85_clib.lib:
	@echo ''
	@echo '--- Building TI85 Library  ---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti85 -x$(OUTPUT_DIRECTORY)/ti85_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti86ansi_clib.lib:
	@echo ''
	@echo '--- Building TI86 ANSI Library  ---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti86 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti86ansi_clib	@$(LISTFILE_DIRECTORY)/ticansi.lst

ti86_clib.lib:
	@echo ''
	@echo '--- Building TI86 Library  ---'
	@echo ''
	$(MAKE)	tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lticalc ; cd	..
	$(LIBLINKER) -DFORti86 -x$(OUTPUT_DIRECTORY)/ti86_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

# vt100	C lib for the Sharp OZ family -	stefano
# use -DPACKEDFONT for tiny 50->80 column modes
ozansi_clib.lib:
	@echo ''
	@echo '--- Building Sharp OZ family ANSI Library  ---'
	@echo ''
	$(RM) -f stdio/ansi/oz/f_ansi_char.o
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd oz ;	$(MAKE)	; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) loz ; cd ..
	$(LIBLINKER) -DFORoz -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ozansi_clib @$(LISTFILE_DIRECTORY)/ozansi.lst

# CPM lib - Stefano/dom
cpm_clib.lib:
	@echo ''
	@echo '--- Building CP/M Library ---'
	@echo ''
	cd fcntl ; $(MAKE) lcpm	; cd ..
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) lcpm	; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpm_clib @$(LISTFILE_DIRECTORY)/cpm.lst

# Sorcerer Exidy lib - Stefano
sorcerer_clib.lib:
	@echo ''
	@echo '--- Building Sorcerer Exidy Library ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic	; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/sorcerer_clib @$(LISTFILE_DIRECTORY)/sorcerer.lst

# Sharp	MZ lib - Stefano
mz_clib.lib:
	@echo ''
	@echo '--- Building Sharp MZ Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/mz_clib @$(LISTFILE_DIRECTORY)/mz.lst

# Sharp	MZ ansi	lib - Stefano
mzansi_clib.lib: 
	@echo ''
	@echo '--- Building Sharp MZ ANSI Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/mzansi_clib @$(LISTFILE_DIRECTORY)/mzansi.lst

# ABC80	library	- Stefano
abc80_clib.lib:
	@echo ''
	@echo '--- Building ABC80 Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/abc80_clib @$(LISTFILE_DIRECTORY)/abc80.lst

# ABC80	ANSI library - Stefano
abc80ansi_clib.lib:
	@echo ''
	@echo '--- Building ABC80 ANSI Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/abc80ansi_clib @$(LISTFILE_DIRECTORY)/abc80ansi.lst

# ABC800 library - Stefano
abc800_clib.lib:
	@echo ''
	@echo '--- Building ABC800 Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/abc800_clib @$(LISTFILE_DIRECTORY)/abc800.lst

# Jupiter ACE library -	Stefano
ace_clib.lib:
	@echo ''
	@echo '--- Building Jupiter Ace	Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd ace ; $(MAKE) ;	cd ..
	cd games ; $(MAKE) lace	; cd ..
	$(LIBLINKER) -DFORjupiter -x$(OUTPUT_DIRECTORY)/ace_clib.lib @$(LISTFILE_DIRECTORY)/ace.lst

# Jupiter ACE ANSI library -	Stefano
aceansi_clib.lib:
	@echo ''
	@echo '--- Building Jupiter Ace	ANSI Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd ace ; $(MAKE) ;	cd ..
	cd games ; $(MAKE) lace	; cd ..
	$(LIBLINKER) -DFORjupiter -x$(OUTPUT_DIRECTORY)/aceansi_clib.lib @$(LISTFILE_DIRECTORY)/aceansi.lst

# Mattel Aquarius library - Stefano
aquarius_clib.lib:
	@echo ''
	@echo '--- Building Mattel Aquarius Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) laquarius ; cd ..
	$(LIBLINKER) -DFORaquarius -x$(OUTPUT_DIRECTORY)/aquarius_clib.lib @$(LISTFILE_DIRECTORY)/aquarius.lst

# Mattel Aquarius ANSI library - Stefano
aquansi_clib.lib:
	@echo ''
	@echo '--- Building Mattel Aquarius ANSI Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) laquarius ; cd ..
	$(LIBLINKER) -DFORaquarius -x$(OUTPUT_DIRECTORY)/aquansi_clib.lib @$(LISTFILE_DIRECTORY)/aquansi.lst

# Xircom REX 6000 library - Dominic
rex_clib.lib:
	@echo ''
	@echo '--- Building Xircom Rex Library	---'
	@echo ''
	cd strings; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd rex	  ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORrex -x$(OUTPUT_DIRECTORY)/rex_clib.lib @$(LISTFILE_DIRECTORY)/rex6000.lst

# Sam Coupe library - Stefano &	Frode
sam_clib.lib:
	@echo ''
	@echo '--- Building Sam	Coupe Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lzx ; cd ..
	$(LIBLINKER) -DFORsam -x$(OUTPUT_DIRECTORY)/sam_clib @$(LISTFILE_DIRECTORY)/sam.lst

# Sam Coupe library - Stefano &	Frode
samansi_clib.lib:
	@echo ''
	@echo '--- Building Sam	Coupe ANSI Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lzx ; cd ..
	$(LIBLINKER) -DFORsam -x$(OUTPUT_DIRECTORY)/samansi_clib @$(LISTFILE_DIRECTORY)/samansi.lst

# Spectravideo SVI library - Stefano
svi_clib.lib:
	@echo ''
	@echo '--- Building Spectravideo Library  ---'
	@echo ''
	$(MAKE)	msxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd games ; $(MAKE) lmsx	; cd ..
	cd msx ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORsvi -x$(OUTPUT_DIRECTORY)/svi_clib @$(LISTFILE_DIRECTORY)/svi.lst

# MSX library - Stefano
msx_clib.lib:
	@echo ''
	@echo '--- Building MSX Library ---'
	@echo ''
	$(MAKE)	msxdeps
	cd fcntl ; $(MAKE) lcpm	; cd ..
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd games ; $(MAKE) lmsx ; cd ..
	cd msx ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORmsx -x$(OUTPUT_DIRECTORY)/msx_clib @$(LISTFILE_DIRECTORY)/msx.lst

# MTX library - Stefano
mtx_clib.lib:
	@echo ''
	@echo '--- Building Memotech MTX Library ---'
	@echo ''
	$(MAKE)	msxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd games ; $(MAKE) lmsx ; cd ..
	cd msx ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORmtx -x$(OUTPUT_DIRECTORY)/mtx_clib @$(LISTFILE_DIRECTORY)/mtx.lst

# Enterprise library - Stefano
enterprise_clib.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd time	; $(MAKE) lenterprise ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lenterprise ; cd	..
	cd enterprise ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORenterprise -x$(OUTPUT_DIRECTORY)/enterprise_clib @$(LISTFILE_DIRECTORY)/enterprise.lst

# Enterprise graphics lib - Stefano
gfxep.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 Graphics Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd graphics ; $(MAKE) lenterprise ; cd ..
	$(LIBLINKER) -DFORenterprise -x$(OUTPUT_DIRECTORY)/gfxep @$(LISTFILE_DIRECTORY)/gfxep.lst

# Enterprise HRG graphics lib - Stefano
gfxephr.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 High Resolution Graphics Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd graphics ; $(MAKE) lenterprisehr ; cd ..
	$(LIBLINKER) -DFORenterprisehr -x$(OUTPUT_DIRECTORY)/gfxephr @$(LISTFILE_DIRECTORY)/gfxephr.lst

# Einstein library - Stefano
einstein.lib:
	@echo ''
	@echo '--- Building Tatung Einstein Library ---'
	@echo ''
	$(MAKE)	msxdeps
	cd games ; $(MAKE) lmsx	; cd ..
	cd msx ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFOReinstein -x$(OUTPUT_DIRECTORY)/einstein @$(LISTFILE_DIRECTORY)/einstein.lst

# SORD M5 library - Stefano
m5_clib.lib:
	@echo ''
	@echo '--- Building SORD M5 Library  ---'
	@echo ''
	$(MAKE)	msxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd msx ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORm5 -x$(OUTPUT_DIRECTORY)/m5_clib @$(LISTFILE_DIRECTORY)/m5.lst

# NASCOM library - Stefano
nascom_clib.lib:
	@echo ''
	@echo '--- Building NASCOM Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORnascom -x$(OUTPUT_DIRECTORY)/nascom_clib @$(LISTFILE_DIRECTORY)/nascom.lst

nasansi_clib.lib:
	@echo ''
	@echo '--- Building NASCOM ANSI	Library	 ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORnascom -x$(OUTPUT_DIRECTORY)/nasansi_clib @$(LISTFILE_DIRECTORY)/nasansi.lst

# Untested C lib for NC100 machines - dom
nc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad NC100 Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/nc_clib @$(LISTFILE_DIRECTORY)/nc100.lst

# Amstrad CPC library -	Stefano
cpc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad CPC	Library	 ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd rs232 ; $(MAKE) lcpc	; cd ..
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpc_clib @$(LISTFILE_DIRECTORY)/cpc.lst
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpccpm @$(LISTFILE_DIRECTORY)/cpccpm.lst

cpcansi_clib.lib:
	@echo ''
	@echo '--- Building Amstrad CPC	ANSI Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd rs232 ; $(MAKE) lcpc	; cd ..
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpcansi_clib @$(LISTFILE_DIRECTORY)/cpcansi.lst

cpcfs.lib:
	@echo ''
	@echo '--- Building Amstrad CPC	fcntl Library ---'
	@echo ''
	cd fcntl ; $(MAKE) lcpc	; cd ..
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpcfs @$(LISTFILE_DIRECTORY)/cpcfs.lst

# Amstrad CPC maths libraries -	Dom
cpc_math.lib:
	@echo ''
	@echo '--- Building Amstrad CPC	Maths Libraries	 ---'
	@echo ''
	cd math/cpcmath ; $(MAKE) ; cd ../..

# Commodore 128	(Z80 mode) library - Stefano
c128ansi_clib.lib:
	@echo ''
	@echo '--- Building Commodore 128 ANSI Library	---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd c128 ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lc128 ; cd ..
	$(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128ansi_clib @$(LISTFILE_DIRECTORY)/c128ansi.lst
	$(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128cpm @$(LISTFILE_DIRECTORY)/c128cpm.lst

# C128 Base text mode graphics lib - Stefano
gfx128.lib:
	@echo ''
	@echo '--- Building Commodore 128 Base Graphics Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	$(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/gfx128 @$(LISTFILE_DIRECTORY)/gfx128.lst

# C128 HRG graphics lib - Stefano
gfx128hr.lib:
	@echo ''
	@echo '--- Building Commodore 128 High Resolution Graphics Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd graphics ; $(MAKE) lc128 ; cd ..
	$(LIBLINKER) -DFORc128hr -x$(OUTPUT_DIRECTORY)/gfx128hr @$(LISTFILE_DIRECTORY)/gfx128hr.lst

# C128 640x480 HRG graphics lib - Stefano
gfx128hr480.lib:
	@echo ''
	@echo '--- Building Commodore 128 640x480 HRG Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd graphics ; $(MAKE) lc128 ; cd ..
	$(LIBLINKER) -DFORc128hr480 -x$(OUTPUT_DIRECTORY)/gfx128hr480 @$(LISTFILE_DIRECTORY)/gfx128hr480.lst

# Grundy NewBrain library - Stefano
newbrain_clib.lib:
	@echo ''
	@echo '--- Building Grundy NewBrain Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd fcntl ; $(MAKE) lnewbrain ; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd time	; $(MAKE) lnewbrain ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/newbrain_clib @$(LISTFILE_DIRECTORY)/newbrain.lst
	$(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/nbcpm_clib @$(LISTFILE_DIRECTORY)/nbcpm.lst

# RCM2/3000 lib
rcmx000_clib.lib:
	@echo ''
	@echo '--- Building RCM2/3000 Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	z80asm -RCMX000	-d -ns -nm -Mo -DFORrcmx000 -x$(OUTPUT_DIRECTORY)/rcmx000_clib @$(LISTFILE_DIRECTORY)/rcmx000.lst

# embedded target - contributed	by Daniel Wallner
embedded_clib.lib:
	@echo ''
	@echo '--- Building Embedded (ns16450) Library	---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) gen ; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORembedded -x$(OUTPUT_DIRECTORY)/embedded_clib @$(LISTFILE_DIRECTORY)/embedded.lst

# Galaksija - Stefano Bodrato
gal_clib.lib:
	@echo ''
	@echo '--- Building Galaksija Library ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE)	gamesdeps
	cd games ; $(MAKE) lgal ; cd ..
	$(LIBLINKER) -DFORgal -x$(OUTPUT_DIRECTORY)/gal_clib @$(LISTFILE_DIRECTORY)/gal.lst

# Sega Master system - contributed by Haroldo O. Pinheiro
sms_clib.lib:
	@echo ''
	@echo '--- Building Sega Master	System Library	---'
	@echo ''
	$(MAKE)	msxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd msx ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORsms -x$(OUTPUT_DIRECTORY)/sms_clib @$(LISTFILE_DIRECTORY)/sms.lst

# Sega SC-3000 - stefano
sc3000_clib.lib:
	@echo ''
	@echo '--- Building SC-3000 System Library ---'
	@echo ''
	$(MAKE)	msxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd msx ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORsc3000 -x$(OUTPUT_DIRECTORY)/sc3000_clib @$(LISTFILE_DIRECTORY)/sc3000.lst

# Test platform	- dom
test_clib.lib:
	@echo ''
	@echo '--- Building Test System	Library	 ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/test_clib @$(LISTFILE_DIRECTORY)/test.lst

# TRS 80 - stefano
trs80_clib.lib:
	@echo ''
	@echo '--- Building TRS	80 Library  ---'
	@echo ''
	$(MAKE)	gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd games ; $(MAKE) ltrs80 ; cd ..
	$(LIBLINKER) -DFORtrs80	-x$(OUTPUT_DIRECTORY)/trs80_clib @$(LISTFILE_DIRECTORY)/trs80.lst

# Canon X-07 lib - Stefano
x07_clib.lib:
	@echo ''
	@echo '--- Building Canon X-07 Library ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic	; cd ..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/x07_clib @$(LISTFILE_DIRECTORY)/x07.lst

# OSCA / FLOS - Stefano
osca_clib.lib:
	@echo ''
	@echo '--- Building Old School Computer Architecture Library ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) generic ; cd ..
	cd stdio ; $(MAKE) generic ; cd	..
	cd printflike ;	$(MAKE)	; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORosca -x$(OUTPUT_DIRECTORY)/osca_clib.lib @$(LISTFILE_DIRECTORY)/osca.lst
	cd fcntl ; $(MAKE) losca ; cd ..

# Z88 maths build - dom
preempt.lib:
	@echo ''
	@echo '--- Building Preemptive threading Library  ---'
	@echo ''
	cd threading/preempt; $(MAKE) ; cd ../..

# SP1 sprite library - aralbrec
sp1:
	@echo
	@echo SP1 Software Sprite Engine
	@echo
	@echo Prior to building	the library you	can customize several
	@echo parameters such as display size, memory map, etc by editing
	@echo the file "customize.asm" found in	{z88dk}/libsrc/sprites/software/sp1/{target}
	@echo Otherwise	the defaults will be used.
	@echo 
	@echo You must specify a target	machine	to build the library.
	@echo Only one version of the library can exist	at a time.
	@echo 
	@echo "make sp1-spectrum      (256x192 pixel, 32x24 attribute)"
	@echo "make sp1-ts2068hr      (512x192 pixel monochrome)"
	@echo "make sp1-zx81hr	      (256x192 pixel monochrome)"
	@echo
	@echo "make sp1-clean	      (recommended prior to building)"
	@echo

sp1-spectrum:
	cd sprites/software/sp1	; $(MAKE) sp1-spectrum;	cd ../../..

sp1-ts2068hr:
	cd sprites/software/sp1	; $(MAKE) sp1-ts2068hr;	cd ../../..

sp1-zx81hr:
	cd sprites/software/sp1	; $(MAKE) sp1-zx81hr; cd ../../..

sp1-clean:
	cd sprites/software/sp1	; $(MAKE) clean; cd ../../..


clean:
	cd ace ; $(MAKE) clean ; cd ..
	cd assert ; $(MAKE) clean ; cd ..
	cd c128 ; $(MAKE) clean ; cd ..
	cd ctype ; $(MAKE) clean ; cd ..
	cd farz88 ; $(MAKE) clean ; cd ..
	cd fcntl ; $(MAKE) clean ; cd ..
	cd math/genmath ; $(MAKE) clean ; cd ../..
	cd math/z88math ; $(MAKE) clean ; cd ../..
	cd math/cpcmath ; $(MAKE) clean ; cd ../..
	cd math/zxmath ; $(MAKE) clean ; cd ../..
	cd graphics ; $(MAKE) clean ; cd ..
	cd malloc ; $(MAKE) clean ; cd ..
	cd net	  ; $(MAKE) clean ; cd ..
	cd printflike ;	$(MAKE)	clean ;	cd ..
	cd rex ; $(MAKE) clean ; cd ..
	cd rs232 ; $(MAKE) clean ; cd ..
	cd setjmp ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
	cd stdio ; $(MAKE) clean ; cd ..
	cd stdlib ; $(MAKE) clean ; cd ..
	cd strings ; $(MAKE) clean ; cd	..
	cd time	; $(MAKE) clean	; cd ..
	cd z80_crt0s; $(MAKE) clean ; cd ..
	cd z88 ; $(MAKE) clean ; cd ..
	cd zxvgs ; $(MAKE) clean ; cd ..
	$(RM) *.lib
	cd games ; $(MAKE) clean ; cd ..
	cd adt ; $(MAKE) clean ; cd ..
	cd balloc ; $(MAKE) clean ; cd ..
	cd im2 ; $(MAKE) clean ; cd ..
	cd rect	; $(MAKE) clean	; cd ..
	cd algorithm ; $(MAKE) clean ; cd ..
	cd debug ; $(MAKE) clean ; cd ..
	cd osca ; $(MAKE)	clean ;	cd ..
	cd oz ; $(MAKE)	clean ;	cd ..
	cd lib3d ; $(MAKE) clean ; cd ..
	cd input ; $(MAKE) clean ; cd ..
	cd abc80 ; $(RM) *.o ; cd ..
	cd abc800 ; $(RM) *.o ;	cd ..
	cd enterprise	; $(MAKE) clean ; cd ..
	cd msx	; $(MAKE) clean ; cd ..
	cd newbrain ; $(RM) *.o	; cd ..
	cd ts2068 ; $(RM) *.o ;	cd ..
	cd vz ;	$(RM) *.o ; cd ..
	cd zx81	; $(MAKE) clean ; cd ..
	cd cpc ; $(RM) *.o ; cd ..
	cd sms ; $(MAKE) clean ; cd ..
	cd threading/preempt	; $(MAKE) clean	; cd ../..
	cd sprites/software/sp1	; $(MAKE) clean	; cd ../../..
	cd stdio_new ; $(MAKE) clean ; cd ..

install:
	cp $(OUTPUT_DIRECTORY)/*.lib ../lib/clibs


