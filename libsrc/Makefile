#
#
# Ah, that'd be nice, a library makefile!
#
# Problems? Contact the person to blame(!) above the section
# for the library
#
# $Id: Makefile,v 1.217 2014-12-23 02:40:31 aralbrec Exp $


include Make.config

# LIBRARIES not built by the global list below:
# - SP1 (build depends on customization and machine target, "make sp1" for options)

all: genlibs z88libs tilibs zxlibs eplibs c128libs cpclibs \
	abc80_clib.lib abc80ansi_clib.lib abc800_clib.lib \
	ace_clib.lib aceansi_clib.lib aquarius_clib.lib aquansi_clib.lib \
	cpm_clib.lib einstein.lib gal_clib.lib m5_clib.lib mc1000_clib.lib mc1000ansi_clib.lib \
	msx_clib.lib mtx_clib.lib mz_clib.lib mzansi_clib.lib \
	nascom_clib.lib nasansi_clib.lib newbrain_clib.lib nc_clib.lib \
	osca_clib.lib oscaansi_clib.lib ozansi_clib.lib p2000_clib.lib p2000ansi_clib.lib \
	pc6001_clib.lib pc6001ansi_clib.lib pps_clib.lib ppsansi_clib.lib \
	rex_clib.lib rcmx000_clib.lib sc3000_clib.lib sms_clib.lib \
	svi_clib.lib sam_clib.lib samansi_clib.lib sorcerer_clib.lib  sos_clib.lib\
	trs80_clib.lib vg5k_clib.lib vg5kansi_clib.lib vz_clib.lib vzansi_clib.lib x07_clib.lib \
	embedded_clib.lib test_clib.lib \
	preempt.lib x1ansi_clib.lib zx80_clib.lib zx81libs sp1-all

genlibs: z80_crt0.lib gen_math.lib debug.lib malloc.lib gendos.lib ndos.lib adt.lib balloc.lib \
	 im2.lib rect.lib algorithm.lib lib3d.lib x11.lib

c128libs: c128ansi_clib.lib gfx128.lib gfx128hr.lib gfx128hr480.lib 

eplibs: enterprise_clib.lib gfxep.lib gfxephr.lib

cpclibs: cpc_clib.lib cpcansi_clib.lib cpcfs.lib cpc_math.lib

z88libs: z88_math.lib z88.lib z88_clib.lib net.lib z88net_clib.lib farz88.lib \
	 z88ansi_clib.lib gfx.lib 

tilibs: ti82ansi_clib.lib ti82_clib.lib ti83ansi_clib.lib ti83_clib.lib \
	ti83pansi_clib.lib ti83p_clib.lib ti85ansi_clib.lib ti85_clib.lib \
	ti86ansi_clib.lib ti86_clib.lib

zxlibs: ts2068_clib.lib ts2068an_clib.lib gfx2068hr.lib gfxspectrum.lib zx_clib.lib zxan_clib.lib zxvgs.lib mzx.lib mzx_tiny.lib zxrom.lib zxfcntl zx232

zx81libs: zx81_clib.lib zx81ansi_clib.lib gfx81.lib gfx81udg.lib gfx81hr64.lib gfx81hr192.lib m81.lib m81_tiny.lib

# moving external shell scripts to makefile to make life easy on
# the windows platform devs (ie Me :-) -- gamesdeps.sh, gfxdeps.sh, tideps.sh

#  short script to sort out games dependencies
gamesdeps:
	$(RM) -f games/*.o

#  short script to sort out gfx dependencies
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

#  short script to sort out ticalc dependencies
tideps:
	$(RM) -f stdio/ticalc/*.o
	$(RM) -f stdio/ansi/ticalc/*.o
	$(RM) -f games/*.o
	$(RM) -f games/ticalc/*.o
	$(RM) -f graphics/*.o
	$(RM) -f graphics/ticalc/*.o
	$(RM) -f graphics/gray/*.o
	$(RM) -f graphics/gray/ticalc/*.o

#  short script to sort out ticalc dependencies
msxdeps:
	$(RM) -f stdio/msx/*.o
	$(RM) -f games/*.o
	$(RM) -f games/msx/*.o
	$(RM) -f graphics/*.o
	$(RM) -f graphics/msx/*.o
	$(RM) -f graphics/msx/surface/*.o
	$(RM) -f psg/msx/*.o
	$(RM) -f msx/*.o

zx81deps:
	$(RM) -f assert/*.o
	$(RM) -f setjmp/*.o
	$(RM) -f printflike/*.o
	$(RM) -f strings/*.o
	$(RM) -f stdlib/*.o
	$(RM) -f stdio/*.o
	$(RM) -f stdio/zx81/*.o
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
	$(RM) -f graphics/zx81/udg/*.o
	$(RM) -f graphics/gray/*.o
	$(RM) -f zx81/*.o
	$(RM) -f zx81/tape/*.o
	$(RM) -f zx81/basic/*.o
	$(RM) -f time/zx81/*.o
	$(MAKE) -C psg clean

# interesting algorithms - aralbrec
algorithm.lib:
	@echo ''
	@echo '--- Building Algorithm Library ---'
	@echo ''
	$(MAKE) -C algorithm 

# rectangles, intervals and points - aralbrec
rect.lib:
	@echo ''
	@echo '--- Building Rectangles Library ---'
	@echo ''
	$(MAKE) -C rect 

# abstract data types library - aralbrec
adt.lib:
	@echo ''
	@echo '--- Building Abstract Data Types Library ---'
	@echo ''
	$(MAKE) -C adt 

# block memory allocator - aralbrec
balloc.lib:
	@echo ''
	@echo '--- Building Block Memory Allocator Library ---'
	@echo ''
	$(MAKE) -C balloc 

# interrupt mode 2 library - aralbrec
im2.lib:
	@echo ''
	@echo '--- Building IM 2 Library ---'
	@echo ''
	$(MAKE) -C im2 

# Garry's z88 far library - garry (probably dom now)
farz88.lib:
	@echo ''
	@echo '--- Building Z88 Far Malloc Library ---'
	@echo ''
	$(MAKE) -C farz88 

# Generic maths build - dom, stefano
gen_math.lib:
	@echo ''
	@echo '--- Building Z80 Generic Maths Library ---'
	@echo ''
	$(MAKE) -C math/genmath

# Z88 maths build - dom
z88_math.lib:
	@echo ''
	@echo '--- Building Z88 Maths Library ---'
	@echo ''
	$(MAKE) -C math/z88math

# Graphics library (for both app and basic - diff libs though!) - dom
gfx.lib:
	@echo ''
	@echo '--- Building Z88 BASIC gfx Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/gfx -DFORz88 @$(LISTFILE_DIRECTORY)/z88gfx.lst
	$(MAKE) gfxdeps
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/gfxapp -DAPPZ88 -DFORz88 @$(LISTFILE_DIRECTORY)/z88gfx.lst

# Fast vector 3D library - stefano
lib3d.lib:
	@echo ''
	@echo '--- Building 3D Library ---'
	@echo ''
	$(MAKE) -C lib3d 

# Xlib / X11 and tiny GUI portable library - stefano
x11.lib:
	@echo ''
	@echo '--- Building X11 emulation Library ---'
	@echo ''
	$(MAKE) -C graphics lx11 

# simple malloc library - dom
# adding multiple heaps and realloc - aralbrec
malloc.lib:
	@echo ''
	@echo '--- Building Near Malloc Library ---'
	@echo ''
	$(MAKE) -C malloc 

ndos.lib:
	$(MAKE) -C fcntl/dummy 

gendos.lib:
	$(MAKE) -C fcntl lgendos 

# Startup code (such as division etc) common to all z80s - dom
z80_crt0.lib:
	@echo ''
	@echo '--- Building Z80 crt0 Library ---'
	@echo ''
	$(MAKE) -C z80_crt0s 

# Z88DK DEBUG utilities
debug.lib:
	@echo ''
	@echo '--- Building DEBUG Library ---'
	@echo ''
	$(MAKE) -C debug 

# Custom z88 routines for application - dom
z88.lib:
	@echo ''
	@echo '--- Building Z88 Custom Library ---'
	@echo ''
	$(MAKE) -C z88 

# ZSock API (wrappers to package calls) - dom
net.lib:
	@echo ''
	@echo '--- Building Z88 ZSock Library ---'
	@echo ''
	$(MAKE) -C net 

# z88 library - dom
z88_clib.lib:
	@echo ''
	@echo '--- Building Z88 Library ---'
	@echo ''
	$(MAKE) -C fcntl lz88 
	$(MAKE) -C stdio lz88 
	$(MAKE) -C stdlib lz88 
	$(MAKE) -C strings 
	$(MAKE) -C printflike
	$(MAKE) -C time lz88
	$(MAKE) -C rs232 lz88
	$(MAKE) -C setjmp
	$(MAKE) -C assert 
	$(MAKE) gamesdeps
	$(MAKE) -C games lz88 
	$(LIBLINKER) -DFORz88 -x$(OUTPUT_DIRECTORY)/z88_clib @$(LISTFILE_DIRECTORY)/z88.lst

# z88 ansi library - dom
z88ansi_clib.lib:
	@echo ''
	@echo '--- Building Z88 ANSI Library ---'
	@echo ''
	$(MAKE) -C fcntl lz88 
	$(MAKE) -C stdio lz88 
	$(MAKE) -C stdlib lz88 
	$(MAKE) -C strings 
	$(MAKE) -C printflike
	$(MAKE) -C time lz88
	$(MAKE) -C rs232 lz88
	$(MAKE) -C setjmp
	$(MAKE) -C assert 
	$(MAKE) gamesdeps
	$(MAKE) -C games lz88 
	$(LIBLINKER) -DFORz88 -x$(OUTPUT_DIRECTORY)/z88ansi_clib @$(LISTFILE_DIRECTORY)/z88ansi.lst

# Network stdio - dom
z88net_clib.lib:
	@echo ''
	@echo '--- Building Z88 Network Aware Library ---'
	@echo ''
	$(MAKE) -C fcntl lz88 
	$(MAKE) -C stdio lz88net
	$(MAKE) -C stdlib lz88 
	$(MAKE) -C strings 
	$(MAKE) -C printflike
	$(MAKE) -C time lz88
	$(MAKE) -C rs232 lz88
	$(MAKE) -C setjmp
	$(MAKE) -C assert 
	$(MAKE) gamesdeps
	$(MAKE) -C games lz88 
	$(LIBLINKER) -DFORz88 -x$(OUTPUT_DIRECTORY)/z88net_clib @$(LISTFILE_DIRECTORY)/z88net.lst

# ZX Spectrum fcntl - dom/stefano
zxfcntl:
	@echo ''
	@echo '--- Building ZX Spectrum fcntl libraries ---'
	@echo ''
	$(MAKE) -C fcntl lzx

# 64/32 column library for ZX Spectrum - dom/stefano
zx_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings 
	$(MAKE) -C stdlib lzx
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C spectrum
	$(MAKE) -C psg
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/zx_clib @$(LISTFILE_DIRECTORY)/zx.lst

# vt100 C lib for spectrum - stefano/dom
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
zxan_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum ANSI Library ---'
	@echo ''
	$(RM) stdio/ansi/spectrum/f_ansi_char.o
	$(MAKE) gfxdeps
	$(MAKE) -C strings 
	$(MAKE) -C stdlib lzx
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C spectrum
	$(MAKE) -C psg
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORzx $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zxan_clib @$(LISTFILE_DIRECTORY)/zxansi.lst

# ZX Spectrum RS232 libraries - stefano
zx232:
	$(MAKE) -C rs232 lzx

# 64/32 column library for TS2068 - dom/stefano/alvin
ts2068_clib.lib:
	@echo ''
	@echo '--- Building TS2068 (Spectrum clone) Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib lzx
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C time lzx
	$(MAKE) gamesdeps
	$(MAKE) -C spectrum
	$(MAKE) -C psg
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORzx -DFORts2068 -x$(OUTPUT_DIRECTORY)/ts2068_clib @$(LISTFILE_DIRECTORY)/ts2068.lst

# vt100 C lib for TS2068 - stefano/dom
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
ts2068an_clib.lib:
	@echo ''
	@echo '--- Building TS2068 (Spectrum clone) ANSI Library ---'
	@echo ''
	$(RM) stdio/ansi/ts2068/f_ansi_*.o
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib lzx
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C time lzx
	$(MAKE) gamesdeps
	$(MAKE) -C spectrum
	$(MAKE) -C psg
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORzx -DFORts2068 -DA80COL -x$(OUTPUT_DIRECTORY)/ts2068an_clib @$(LISTFILE_DIRECTORY)/ts2068an.lst

# TS2068 HRG graphics lib - Stefano
gfx2068hr.lib:
	@echo ''
	@echo '--- Building TS2068 High Resolution Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORgfx2068hr -x$(OUTPUT_DIRECTORY)/gfx2068hr @$(LISTFILE_DIRECTORY)/gfx2068hr.lst

# TS2068 HRG graphics lib - Stefano
gfxspectrum.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/gfxspectrum @$(LISTFILE_DIRECTORY)/gfxspectrum.lst

# ZXROM - stefano
zxrom.lib:
	@echo ''
	@echo '--- Building ZXROM Library ---'
	@echo ''
	$(MAKE) gamesdeps
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/zxrom @$(LISTFILE_DIRECTORY)/zxrom.lst

# ZXVGS - yarek
zxvgs.lib:
	@echo ''
	@echo '--- Building ZXVGS Library ---'
	@echo ''
	$(MAKE) -C fcntl lzxvgs
	$(MAKE) -C zxvgs
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/zxvgs @$(LISTFILE_DIRECTORY)/zxvgs.lst

# ZX Spectrum maths library - Stefano
mzx.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Maths Library ---'
	@echo ''
	$(MAKE) -C math/zxmath mzx

mzx_tiny.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Tiny Maths Library ---'
	@echo ''
	$(MAKE) -C math/zxmath mzx_tiny

# Philips P2000 lib - Stefano
p2000_clib.lib:
	@echo ''
	@echo '--- Building Philips P2000 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C psg
	$(MAKE) -C games lp2000
	$(LIBLINKER) -DFORp2000 -x$(OUTPUT_DIRECTORY)/p2000_clib @$(LISTFILE_DIRECTORY)/p2000.lst

# Philips P2000 ansi lib - Stefano
p2000ansi_clib.lib:
	@echo ''
	@echo '--- Building Philips P2000 ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C psg
	$(MAKE) -C games lp2000
	$(LIBLINKER) -DFORp2000 -x$(OUTPUT_DIRECTORY)/p2000ansi_clib @$(LISTFILE_DIRECTORY)/p2000ansi.lst

# PC6001 lib - Stefano
pc6001_clib.lib:
	@echo ''
	@echo '--- Building PC6001 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C psg
	$(LIBLINKER) -DFORpc6001 -x$(OUTPUT_DIRECTORY)/pc6001_clib @$(LISTFILE_DIRECTORY)/pc6001.lst

# PC6001 ansi lib - Stefano
pc6001ansi_clib.lib:
	@echo ''
	@echo '--- Building PC6001 ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C psg
	$(LIBLINKER) -DFORpc6001 -x$(OUTPUT_DIRECTORY)/pc6001ansi_clib @$(LISTFILE_DIRECTORY)/pc6001ansi.lst

# Native for sprinter - dom
pps_clib.lib:
	@echo ''
	@echo '--- Building Sprinter Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib lzx
	$(MAKE) -C stdio generic
	$(MAKE) -C fcntl lpps
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C time lpps
	$(MAKE) gamesdeps
	$(MAKE) -C spectrum 
	$(MAKE) -C psg
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/pps_clib @$(LISTFILE_DIRECTORY)/pps.lst

# vt100 for sprinter - dom
ppsansi_clib.lib:
	@echo ''
	@echo '--- Building Sprinter Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib lzx
	$(MAKE) -C stdio generic
	$(MAKE) -C fcntl lpps
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C time lpps
	$(MAKE) gamesdeps
	$(MAKE) -C spectrum 
	$(MAKE) -C psg
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/ppsansi_clib @$(LISTFILE_DIRECTORY)/ppsansi.lst

# VZ200/300 lib - Stefano
vz_clib.lib:
	@echo ''
	@echo '--- Building VZ200/300 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lvz
	$(LIBLINKER) -DFORvz -x$(OUTPUT_DIRECTORY)/vz_clib @$(LISTFILE_DIRECTORY)/vz200.lst

# VZ200 ansi lib - Stefano
vzansi_clib.lib:
	@echo ''
	@echo '--- Building VZ200/300 ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lvz
	$(LIBLINKER) -DFORvz -x$(OUTPUT_DIRECTORY)/vzansi_clib @$(LISTFILE_DIRECTORY)/vzansi.lst

# ZX81 lib - Stefano
zx80_clib.lib:
	@echo ''
	@echo '--- Building ZX80 Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C strings
	$(MAKE) -C stdlib lzx80
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lzx
	$(MAKE) -C psg
	$(LIBLINKER) -DFORzx80 -x$(OUTPUT_DIRECTORY)/zx80_clib @$(LISTFILE_DIRECTORY)/zx80.lst
	$(MAKE) zx81deps

# ZX81 lib - Stefano
zx81_clib.lib:
	@echo ''
	@echo '--- Building ZX81 Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic_iy 
	$(MAKE) -C printflike generic_iy
	$(MAKE) -C setjmp generic_iy
	$(MAKE) -C assert generic_iy
	$(MAKE) gamesdeps
	$(MAKE) -C games lzx81
	$(MAKE) -C psg generic_iy
	$(LIBLINKER) -IXIY -DFORzx81 -x$(OUTPUT_DIRECTORY)/zx81_clib @$(LISTFILE_DIRECTORY)/zx81.lst
	$(MAKE) zx81deps

# ZX81 ansi lib - Stefano
zx81ansi_clib.lib:
	@echo ''
	@echo '--- Building ZX81 ANSI Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(RM) stdio/ansi/zx81/f_ansi_char.o
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic_iy 
	$(MAKE) -C printflike generic_iy
	$(MAKE) -C setjmp generic_iy
	$(MAKE) -C assert generic_iy
	$(MAKE) gamesdeps
	$(MAKE) -C games lzx81
	$(MAKE) -C psg generic_iy
	$(LIBLINKER) -IXIY -DFORzx81 $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zx81ansi_clib @$(LISTFILE_DIRECTORY)/zx81ansi.lst
	$(MAKE) zx81deps

# ZX81 std graphics lib - Stefano
gfx81.lib:
	@echo ''
	@echo '--- Building ZX81 Standard Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(LIBLINKER) -IXIY -DFORzx81 -x$(OUTPUT_DIRECTORY)/gfx81 @$(LISTFILE_DIRECTORY)/gfx81.lst
	$(MAKE) zx81deps

# ZX81 UDG based graphics lib - Stefano
gfx81udg.lib:
	@echo ''
	@echo '--- Building ZX81 UDG based Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(LIBLINKER) -IXIY -DFORzx81udg -x$(OUTPUT_DIRECTORY)/gfx81udg @$(LISTFILE_DIRECTORY)/gfx81udg.lst
	$(MAKE) zx81deps

# ZX81 HR graphics lib - Stefano
gfx81hr64.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (64 rows)  ---'
	@echo ''
	$(MAKE) zx81deps
	$(LIBLINKER) -IXIY -DFORzx81hr64 -x$(OUTPUT_DIRECTORY)/gfx81hr64 @$(LISTFILE_DIRECTORY)/gfx81hr.lst
	$(MAKE) zx81deps
	$(LIBLINKER) -IXIY -DFORzx81hr64 -x$(OUTPUT_DIRECTORY)/gfx81arx64 @$(LISTFILE_DIRECTORY)/gfx81arx.lst
	$(MAKE) zx81deps
	$(LIBLINKER) -IXIY -DFORzx81mt64 -x$(OUTPUT_DIRECTORY)/gfx81mt64 @$(LISTFILE_DIRECTORY)/gfx81mt.lst
	$(MAKE) zx81deps

gfx81hr192.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (192 rows)  ---'
	@echo ''
	$(MAKE) zx81deps
	$(LIBLINKER) -IXIY -DFORzx81hr192 -x$(OUTPUT_DIRECTORY)/gfx81hr192 @$(LISTFILE_DIRECTORY)/gfx81hr.lst
	$(MAKE) zx81deps
	$(LIBLINKER) -IXIY -DFORzx81hr192 -x$(OUTPUT_DIRECTORY)/gfx81arx192 @$(LISTFILE_DIRECTORY)/gfx81arx.lst
	$(MAKE) zx81deps
	$(LIBLINKER) -IXIY -DFORzx81mt192 -x$(OUTPUT_DIRECTORY)/gfx81mt192 @$(LISTFILE_DIRECTORY)/gfx81mt.lst
	$(MAKE) zx81deps
	$(LIBLINKER) -IXIY -DFORzx81g007 -x$(OUTPUT_DIRECTORY)/gfx81g007 @$(LISTFILE_DIRECTORY)/gfx81g007.lst
	$(MAKE) zx81deps

# ZX81 maths library - Stefano
m81.lib:
	@echo ''
	@echo '--- Building ZX 81 Maths Library ---'
	@echo ''
	$(MAKE) -C math/zxmath m81

m81_tiny.lib:
	@echo ''
	@echo '--- Building ZX 81 Tiny Maths Library ---'
	@echo ''
	$(MAKE) -C math/zxmath m81_tiny

# Texas Instrument's calculators: - stefano/henk
# almost the same lib code with different -D flag set
# that's why we force most of the lib code to be rebuilt (tideps.sh)
ti82ansi_clib.lib:
	@echo ''
	@echo '--- Building TI82 ANSI Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti82 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti82ansi_clib @$(LISTFILE_DIRECTORY)/ticansi.lst

ti82_clib.lib:
	@echo ''
	@echo '--- Building TI82 Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti82 -x$(OUTPUT_DIRECTORY)/ti82_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83ansi_clib.lib:
	@echo ''
	@echo '--- Building TI83 ANSI Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti83 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83ansi_clib @$(LISTFILE_DIRECTORY)/ticansi.lst

ti83_clib.lib:
	@echo ''
	@echo '--- Building TI83 Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti83 -x$(OUTPUT_DIRECTORY)/ti83_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83pansi_clib.lib:
	@echo ''
	@echo '--- Building TI83+ ANSI Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti83p -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83pansi_clib @$(LISTFILE_DIRECTORY)/ticansi.lst

ti83p_clib.lib:
	@echo ''
	@echo '--- Building TI83+ Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti83p -x$(OUTPUT_DIRECTORY)/ti83p_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti85ansi_clib.lib:
	@echo ''
	@echo '--- Building TI85 ANSI Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti85 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti85ansi_clib @$(LISTFILE_DIRECTORY)/ticansi.lst

ti85_clib.lib:
	@echo ''
	@echo '--- Building TI85 Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti85 -x$(OUTPUT_DIRECTORY)/ti85_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti86ansi_clib.lib:
	@echo ''
	@echo '--- Building TI86 ANSI Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti86 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti86ansi_clib @$(LISTFILE_DIRECTORY)/ticansi.lst

ti86_clib.lib:
	@echo ''
	@echo '--- Building TI86 Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti86 -x$(OUTPUT_DIRECTORY)/ti86_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

# vt100 C lib for the Sharp OZ family - stefano
# use -DPACKEDFONT for tiny 50->80 column modes
ozansi_clib.lib:
	@echo ''
	@echo '--- Building Sharp OZ family ANSI Library ---'
	@echo ''
	$(RM) -f stdio/ansi/oz/f_ansi_char.o
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C oz 
	$(MAKE) gamesdeps
	$(MAKE) -C games loz
	$(LIBLINKER) -DFORoz -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ozansi_clib @$(LISTFILE_DIRECTORY)/ozansi.lst

# CPM lib - Stefano/dom
cpm_clib.lib:
	@echo ''
	@echo '--- Building CP/M Library ---'
	@echo ''
	$(MAKE) -C fcntl lcpm
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio lcpm
	$(MAKE) -C printflike
	$(MAKE) -C time lcpm
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpm_clib @$(LISTFILE_DIRECTORY)/cpm.lst

# Sorcerer Exidy lib - Stefano
sorcerer_clib.lib:
	@echo ''
	@echo '--- Building Sorcerer Exidy Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORsorcerer -x$(OUTPUT_DIRECTORY)/sorcerer_clib @$(LISTFILE_DIRECTORY)/sorcerer.lst

# Sharp MZ lib - Stefano
mz_clib.lib:
	@echo ''
	@echo '--- Building Sharp MZ Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/mz_clib @$(LISTFILE_DIRECTORY)/mz.lst

# Sharp MZ ansi lib - Stefano
mzansi_clib.lib: 
	@echo ''
	@echo '--- Building Sharp MZ ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/mzansi_clib @$(LISTFILE_DIRECTORY)/mzansi.lst

# ABC80 Library - Stefano
abc80_clib.lib:
	@echo ''
	@echo '--- Building ABC80 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/abc80_clib @$(LISTFILE_DIRECTORY)/abc80.lst

# ABC80 ANSI library - Stefano
abc80ansi_clib.lib:
	@echo ''
	@echo '--- Building ABC80 ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/abc80ansi_clib @$(LISTFILE_DIRECTORY)/abc80ansi.lst

# ABC800 library - Stefano
abc800_clib.lib:
	@echo ''
	@echo '--- Building ABC800 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/abc800_clib @$(LISTFILE_DIRECTORY)/abc800.lst

# Jupiter ACE library - Stefano
ace_clib.lib:
	@echo ''
	@echo '--- Building Jupiter Ace Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C ace 
	$(MAKE) -C games lace
	$(LIBLINKER) -DFORjupiter -x$(OUTPUT_DIRECTORY)/ace_clib.lib @$(LISTFILE_DIRECTORY)/ace.lst

# Jupiter ACE ANSI library - Stefano
aceansi_clib.lib:
	@echo ''
	@echo '--- Building Jupiter Ace ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C ace 
	$(MAKE) -C games lace
	$(LIBLINKER) -DFORjupiter -x$(OUTPUT_DIRECTORY)/aceansi_clib.lib @$(LISTFILE_DIRECTORY)/aceansi.lst

# Mattel Aquarius library - Stefano
aquarius_clib.lib:
	@echo ''
	@echo '--- Building Mattel Aquarius Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C psg
	$(MAKE) -C games laquarius 
	$(LIBLINKER) -DFORaquarius -x$(OUTPUT_DIRECTORY)/aquarius_clib.lib @$(LISTFILE_DIRECTORY)/aquarius.lst

# Mattel Aquarius ANSI library - Stefano
aquansi_clib.lib:
	@echo ''
	@echo '--- Building Mattel Aquarius ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C psg
	$(MAKE) -C games laquarius
	$(LIBLINKER) -DFORaquarius -x$(OUTPUT_DIRECTORY)/aquansi_clib.lib @$(LISTFILE_DIRECTORY)/aquansi.lst

# Xircom REX 6000 library - Dominic
rex_clib.lib:
	@echo ''
	@echo '--- Building Xircom Rex Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C setjmp
	$(MAKE) -C rex
	$(LIBLINKER) -DFORrex -x$(OUTPUT_DIRECTORY)/rex_clib.lib @$(LISTFILE_DIRECTORY)/rex6000.lst

# Sam Coupe library - Stefano & Frode
sam_clib.lib:
	@echo ''
	@echo '--- Building Sam Coupe Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C time lzx
	$(MAKE) gamesdeps
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORsam -x$(OUTPUT_DIRECTORY)/sam_clib @$(LISTFILE_DIRECTORY)/sam.lst

# Sam Coupe library - Stefano & Frode
samansi_clib.lib:
	@echo ''
	@echo '--- Building Sam Coupe ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C time lzx
	$(MAKE) gamesdeps
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORsam -x$(OUTPUT_DIRECTORY)/samansi_clib @$(LISTFILE_DIRECTORY)/samansi.lst

# Spectravideo SVI library - Stefano
svi_clib.lib:
	@echo ''
	@echo '--- Building Spectravideo Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C games lmsx
	$(MAKE) -C msx
	$(MAKE) -C psg
	$(LIBLINKER) -DFORsvi -x$(OUTPUT_DIRECTORY)/svi_clib @$(LISTFILE_DIRECTORY)/svi.lst

# MSX library - Stefano
msx_clib.lib:
	@echo ''
	@echo '--- Building MSX Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C fcntl lcpm
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio lcpm
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C games lmsx
	$(MAKE) -C msx
	$(MAKE) -C psg
	$(LIBLINKER) -DFORmsx -x$(OUTPUT_DIRECTORY)/msx_clib @$(LISTFILE_DIRECTORY)/msx.lst

# MTX library - Stefano
mtx_clib.lib:
	@echo ''
	@echo '--- Building Memotech MTX Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C games lmsx
	$(MAKE) -C msx
	$(MAKE) -C psg
	$(LIBLINKER) -DFORmtx -x$(OUTPUT_DIRECTORY)/mtx_clib @$(LISTFILE_DIRECTORY)/mtx.lst

# Enterprise library - Stefano
enterprise_clib.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C time lenterprise
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lenterprise
	$(MAKE) -C enterprise 
	$(LIBLINKER) -DFORenterprise -x$(OUTPUT_DIRECTORY)/enterprise_clib @$(LISTFILE_DIRECTORY)/enterprise.lst

# Enterprise graphics lib - Stefano
gfxep.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C graphics lenterprise
	$(LIBLINKER) -DFORenterprise -x$(OUTPUT_DIRECTORY)/gfxep @$(LISTFILE_DIRECTORY)/gfxep.lst

# Enterprise HRG graphics lib - Stefano
gfxephr.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 High Resolution Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C graphics lenterprisehr
	$(LIBLINKER) -DFORenterprisehr -x$(OUTPUT_DIRECTORY)/gfxephr @$(LISTFILE_DIRECTORY)/gfxephr.lst

# Einstein library - Stefano
einstein.lib:
	@echo ''
	@echo '--- Building Tatung Einstein Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games lmsx
	$(MAKE) -C msx
	$(MAKE) -C psg
	$(LIBLINKER) -DFOReinstein -x$(OUTPUT_DIRECTORY)/einstein @$(LISTFILE_DIRECTORY)/einstein.lst

# SORD M5 library - Stefano
m5_clib.lib:
	@echo ''
	@echo '--- Building SORD M5 Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C strings 
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C msx
	$(MAKE) -C psg
	$(LIBLINKER) -DFORm5 -x$(OUTPUT_DIRECTORY)/m5_clib @$(LISTFILE_DIRECTORY)/m5.lst

# MC-1000 library - Stefano
mc1000_clib.lib:
	@echo ''
	@echo '--- Building CCE MC-1000 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings 
	$(MAKE) -C stdlib lmc1000
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lmc1000
	$(MAKE) -C psg
	$(LIBLINKER) -DFORmc1000 -x$(OUTPUT_DIRECTORY)/mc1000_clib @$(LISTFILE_DIRECTORY)/mc1000.lst

# MC-1000 ANSI library - Stefano
mc1000ansi_clib.lib:
	@echo ''
	@echo '--- Building CCE MC-1000 ANSI Library ---'
	@echo ''
	$(RM) stdio/ansi/mc1000/f_ansi_char.o
	$(MAKE) gfxdeps
	$(MAKE) -C strings 
	$(MAKE) -C stdlib lmc1000
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lmc1000
	$(MAKE) -C psg
	$(LIBLINKER) -DFORmc1000 $(COLDEFS) -x$(OUTPUT_DIRECTORY)/mc1000ansi_clib @$(LISTFILE_DIRECTORY)/mc1000ansi.lst

# NASCOM library - Stefano
nascom_clib.lib:
	@echo ''
	@echo '--- Building NASCOM Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORnascom -x$(OUTPUT_DIRECTORY)/nascom_clib @$(LISTFILE_DIRECTORY)/nascom.lst

nasansi_clib.lib:
	@echo ''
	@echo '--- Building NASCOM ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORnascom -x$(OUTPUT_DIRECTORY)/nasansi_clib @$(LISTFILE_DIRECTORY)/nasansi.lst

# Untested C lib for NC100 machines - dom
nc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad NC100 Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C fcntl lnc
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/nc_clib @$(LISTFILE_DIRECTORY)/nc100.lst

# Amstrad CPC library - Stefano
cpc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad CPC Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C rs232 lcpc
	$(MAKE) -C psg
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpc_clib @$(LISTFILE_DIRECTORY)/cpc.lst
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpccpm @$(LISTFILE_DIRECTORY)/cpccpm.lst

cpcansi_clib.lib:
	@echo ''
	@echo '--- Building Amstrad CPC ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C rs232 lcpc
	$(MAKE) -C psg
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpcansi_clib @$(LISTFILE_DIRECTORY)/cpcansi.lst

cpcfs.lib:
	@echo ''
	@echo '--- Building Amstrad CPC fcntl Library ---'
	@echo ''
	$(MAKE) -C fcntl lcpc
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpcfs @$(LISTFILE_DIRECTORY)/cpcfs.lst

# Amstrad CPC maths libraries - Dom
cpc_math.lib:
	@echo ''
	@echo '--- Building Amstrad CPC Maths Libraries ---'
	@echo ''
	$(MAKE) -C math/cpcmath 

# Commodore 128 (Z80 mode) library - Stefano
c128ansi_clib.lib:
	@echo ''
	@echo '--- Building Commodore 128 ANSI Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C c128 
	$(MAKE) gamesdeps
	$(MAKE) -C games lc128
	$(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128ansi_clib @$(LISTFILE_DIRECTORY)/c128ansi.lst
	$(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128cpm @$(LISTFILE_DIRECTORY)/c128cpm.lst

# C128 Base text mode graphics lib - Stefano
gfx128.lib:
	@echo ''
	@echo '--- Building Commodore 128 Base Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/gfx128 @$(LISTFILE_DIRECTORY)/gfx128.lst

# C128 HRG graphics lib - Stefano
gfx128hr.lib:
	@echo ''
	@echo '--- Building Commodore 128 High Resolution Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C graphics lc128
	$(LIBLINKER) -DFORc128hr -x$(OUTPUT_DIRECTORY)/gfx128hr @$(LISTFILE_DIRECTORY)/gfx128hr.lst

# C128 640x480 HRG graphics lib - Stefano
gfx128hr480.lib:
	@echo ''
	@echo '--- Building Commodore 128 640x480 HRG Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C graphics lc128
	$(LIBLINKER) -DFORc128hr480 -x$(OUTPUT_DIRECTORY)/gfx128hr480 @$(LISTFILE_DIRECTORY)/gfx128hr480.lst

# Grundy NewBrain library - Stefano
newbrain_clib.lib:
	@echo ''
	@echo '--- Building Grundy NewBrain Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C fcntl lnewbrain
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C time lnewbrain
	$(MAKE) -C assert
	$(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/newbrain_clib @$(LISTFILE_DIRECTORY)/newbrain.lst
	$(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/nbcpm_clib @$(LISTFILE_DIRECTORY)/nbcpm.lst

# RCM2/3000 lib
rcmx000_clib.lib:
	@echo ''
	@echo '--- Building RCM2/3000 Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	z80asm -RCMX000 -d -ns -nm -Mo -DFORrcmx000 -x$(OUTPUT_DIRECTORY)/rcmx000_clib @$(LISTFILE_DIRECTORY)/rcmx000.lst

# embedded target - contributed by Daniel Wallner
embedded_clib.lib:
	@echo ''
	@echo '--- Building Embedded (ns16450) Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio gen
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORembedded -x$(OUTPUT_DIRECTORY)/embedded_clib @$(LISTFILE_DIRECTORY)/embedded.lst

# Galaksija - Stefano Bodrato
gal_clib.lib:
	@echo ''
	@echo '--- Building Galaksija Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lgal
	$(LIBLINKER) -DFORgal -x$(OUTPUT_DIRECTORY)/gal_clib @$(LISTFILE_DIRECTORY)/gal.lst

# Camputers Lynx - Stefano Bodrato
lynx_clib.lib:
	@echo ''
	@echo '--- Building Camputers Lynx Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lgal
	$(LIBLINKER) -DFORlynx -x$(OUTPUT_DIRECTORY)/lynx_clib @$(LISTFILE_DIRECTORY)/lynx.lst

# Sega Master system - contributed by Haroldo O. Pinheiro
sms_clib.lib:
	@echo ''
	@echo '--- Building Sega Master System Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C msx
	$(MAKE) -C psg
	$(LIBLINKER) -DFORsms -x$(OUTPUT_DIRECTORY)/sms_clib @$(LISTFILE_DIRECTORY)/sms.lst

# Sega SC-3000 - stefano
sc3000_clib.lib:
	@echo ''
	@echo '--- Building SC-3000 System Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C msx
	$(MAKE) -C psg
	$(LIBLINKER) -DFORsc3000 -x$(OUTPUT_DIRECTORY)/sc3000_clib @$(LISTFILE_DIRECTORY)/sc3000.lst

# Test platform - dom
test_clib.lib:
	@echo ''
	@echo '--- Building Test System Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/test_clib @$(LISTFILE_DIRECTORY)/test.lst

# TRS 80 - stefano
trs80_clib.lib:
	@echo ''
	@echo '--- Building TRS 80 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games ltrs80
	$(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/trs80_clib @$(LISTFILE_DIRECTORY)/trs80.lst

# Canon X-07 lib - Stefano
x07_clib.lib:
	@echo ''
	@echo '--- Building Canon X-07 Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/x07_clib @$(LISTFILE_DIRECTORY)/x07.lst

# Sharp X1 (ANSI VT) - Karl Von Dyson (X1s.org)
x1ansi_clib.lib:
	@echo ''
	@echo '--- Building Sharp X1 ANSI Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib lx1
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C time lx1
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C psg
	$(MAKE) -C x1 
	$(LIBLINKER) -DFORx1 -x$(OUTPUT_DIRECTORY)/x1ansi_clib @$(LISTFILE_DIRECTORY)/x1ansi.lst

# Philips VG5000 lib - Joaopa, Stefano
vg5k_clib.lib:
	@echo ''
	@echo '--- Building Philips VG5000 Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lvg5k
	$(LIBLINKER) -DFORvg5k -x$(OUTPUT_DIRECTORY)/vg5k_clib @$(LISTFILE_DIRECTORY)/vg5k.lst

# Philips VG5000 ansi lib - Joaopa, Stefano
vg5kansi_clib.lib:
	@echo ''
	@echo '--- Building Philips VG5000 ANSI Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio generic
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lvg5k
	$(LIBLINKER) -DFORvg5k -x$(OUTPUT_DIRECTORY)/vg5kansi_clib @$(LISTFILE_DIRECTORY)/vg5kansi.lst

# S-OS (The Sentinel) - Stefano
sos_clib.lib:
	@echo ''
	@echo '--- Building S-OS (The Sentinel) Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib generic
	$(MAKE) -C stdio lcpm
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C sos 
	$(LIBLINKER) -DFORsos -x$(OUTPUT_DIRECTORY)/sos_clib.lib @$(LISTFILE_DIRECTORY)/sos.lst

# OSCA / FLOS - Stefano
osca_clib.lib:
	@echo ''
	@echo '--- Building Old School Computer Architecture Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib losca
	$(MAKE) -C stdio lcpm
	$(MAKE) -C printflike
	$(MAKE) -C rs232 losca
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C sdcard clean
	$(MAKE) -C fcntl losca
	$(LIBLINKER) -DFORosca -DSDHC_SUPPORT -x$(OUTPUT_DIRECTORY)/osca_clib.lib @$(LISTFILE_DIRECTORY)/osca.lst

oscaansi_clib.lib:
	@echo ''
	@echo '--- Building OSCA Library ANSI VT version ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C stdlib losca
	$(MAKE) -C stdio lcpm
	$(MAKE) -C rs232 losca
	$(MAKE) -C printflike
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C sdcard clean
	$(MAKE) -C fcntl losca
	$(LIBLINKER) -DFORosca -DSDHC_SUPPORT -x$(OUTPUT_DIRECTORY)/oscaansi_clib.lib @$(LISTFILE_DIRECTORY)/oscaansi.lst

# Preempt multitasking library - dom
preempt.lib:
	@echo ''
	@echo '--- Building Preemptive threading Library ---'
	@echo ''
	$(MAKE) -C threading/preempt

# SP1 sprite library - aralbrec
sp1:
	@echo
	@echo SP1 Software Sprite Engine
	@echo
	@echo Prior to building the library you can customize several
	@echo parameters such as display size, memory map, etc by editing
	@echo the file "customize.asm" found in {z88dk}/libsrc/sprites/software/sp1/{target}
	@echo Otherwise the defaults will be used.
	@echo 
	@echo You must specify a target machine to build the library.
	@echo Only one version of the library can exist at a time.
	@echo 
	@echo "make sp1-spectrum      (256x192 pixel, 32x24 attribute)"
	@echo "make sp1-ts2068hr      (512x192 pixel monochrome)"
	@echo "make sp1-zx81hr        (256x192 pixel monochrome)"
	@echo
	@echo "make sp1-clean         (recommended prior to building)"
	@echo

sp1-all:
	$(MAKE) -C sprites/software/sp1  sp1-all

sp1-spectrum:
	$(MAKE) -C sprites/software/sp1  sp1-spectrum

sp1-ts2068hr:
	$(MAKE) -C sprites/software/sp1  sp1-ts2068hr

sp1-zx81hr:
	$(MAKE) -C sprites/software/sp1  sp1-zx81hr

sp1-clean:
	$(MAKE) -C sprites/software/sp1 clean


clean:
	$(MAKE) -C ace clean
	$(MAKE) -C assert clean
	$(MAKE) -C c128 clean
	$(MAKE) -C ctype clean
	$(MAKE) -C farz88 clean
	$(MAKE) -C fcntl clean
	$(MAKE) -C math/genmath clean
	$(MAKE) -C math/z88math clean
	$(MAKE) -C math/cpcmath clean
	$(MAKE) -C math/zxmath clean
	$(MAKE) -C graphics clean
	$(MAKE) -C malloc clean
	$(MAKE) -C net clean
	$(MAKE) -C printflike clean
	$(MAKE) -C rex clean
	$(MAKE) -C rs232 clean
	$(MAKE) -C setjmp clean
	$(MAKE) -C spectrum clean
	$(MAKE) -C stdio clean
	$(MAKE) -C stdlib clean
	$(MAKE) -C strings clean
	$(MAKE) -C time clean
	$(MAKE) -C z80_crt0s clean
	$(MAKE) -C z88 clean
	$(MAKE) -C zxvgs clean
	$(MAKE) -C adt clean
	$(MAKE) -C balloc clean
	$(MAKE) -C im2 clean
	$(MAKE) -C rect clean
	$(MAKE) -C algorithm clean
	$(MAKE) -C debug clean
	$(MAKE) -C osca clean
	$(MAKE) -C oz clean
	$(MAKE) -C lib3d clean
	$(MAKE) -C input clean	
	$(RM) abc80/*.o
	$(RM) abc800/*.o
	$(MAKE) -C enterprise clean
	$(MAKE) -C msx clean
	$(MAKE) -C psg clean
	$(RM) newbrain/*.o
	$(RM) ts2068/*.o
	$(RM) vz/*.o
	$(MAKE) -C zx81 clean
	$(RM) cpc/*.o
	$(MAKE) -C sms clean
	$(MAKE) -C sos clean
	$(MAKE) -C threading/preempt clean
	$(MAKE) -C sprites/software/sp1 clean
	$(MAKE) -C stdio_new clean
	$(MAKE) -C sdcard clean
	$(MAKE) -C games clean
	$(MAKE) -C x1 clean
	$(RM) *.lib

install:
	cp $(OUTPUT_DIRECTORY)/*.lib ../lib/clibs


