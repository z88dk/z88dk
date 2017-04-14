#
#
# Ah, that'd be nice, a library makefile!
#
# Problems? Contact the person to blame(!) above the section
# for the library
#
# $Id: Makefile,v 1.265 2016/11/25 14:45:01 stefano Exp $


include Make.config

# LIBRARIES not built by the global list below:
# - SP1 (build depends on customization and machine target, "make sp1" for options)

all: genlibs z88libs tilibs zxlibs eplibs c128libs cpclibs \
	abc80_clib.lib abc800_clib.lib \
	ace_clib.lib aquarius_clib.lib aussie.lib bee_clib.lib microbee.lib c7420_clib.lib\
	cpm_clib.lib einstein.lib gal_clib.lib m5_clib.lib mc1000_clib.lib \
	msx_clib.lib mtx_clib.lib mz_clib.lib  \
	nascom_clib.lib  newbrain_clib.lib nc_clib.lib \
	osca_clib.lib ozansi_clib.lib pacman_clib.lib p2000_clib.lib  \
	pc6001_clib.lib pps_clib.lib px4.lib px8.lib \
	rex_clib.lib sc3000_clib.lib sms_clib.lib lynx_clib.lib \
	svi_clib.lib sam_clib.lib  sorcerer_clib.lib  sos_clib.lib tiki100.lib\
	trs80_clib.lib vg5k_clib.lib vz_clib.lib  x07_clib.lib \
	embedded_clib.lib test_clib.lib z1013_clib.lib z9001_clib.lib kc_clib.lib \
	preempt.lib x1ansi_clib.lib zx80_clib.lib zx81libs sp1-all rcmx000_clib.lib

genlibs: z80_crt0.lib math48.lib gen_math.lib debug.lib malloc.lib gendos.lib ndos.lib adt.lib balloc.lib \
	 im2.lib rect.lib algorithm.lib lib3d.lib x11.lib

c128libs: c128ansi_clib.lib gfx128.lib gfx128hr.lib gfx128hr480.lib 

eplibs: enterprise_clib.lib gfxep.lib gfxephr.lib

cpclibs: cpc_clib.lib  cpcfs.lib cpc_math.lib

z88libs: z88_math.lib  z88_clib.lib net.lib z88net_clib.lib farz88.lib 

tilibs: ti82_clib.lib ti83_clib.lib ti83p_clib.lib ti85_clib.lib ti86_clib.lib

zxlibs: ts2068_clib.lib gfx2068hr.lib gfxspectrum.lib zx_clib.lib zxvgs.lib mzx.lib mzx_tiny.lib zxrom.lib zxfcntl zx232

zx81libs: zx81_clib.lib gfx81.lib gfxlambda.lib gfx81udg.lib gfx81hr64.lib gfx81hr192.lib m81.lib m81_tiny.lib mlambda.lib mlambda_tiny.lib lambda_clib.lib

# moving external shell scripts to makefile to make life easy on
# the windows platform devs (ie Me :-) -- gamesdeps.sh, gfxdeps.sh, tideps.sh

#  short script to sort out games dependencies
gamesdeps:
	$(RM) -f games/*.o

#  short script to sort out stdlib dependencies
stdldeps:
	$(RM) -f stdlib/sleep.o
	$(RM) -f stdlib/csleep.o
	$(RM) -f stdlib/delay.o

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
	$(RM) -f strings/*.o
	$(RM) -f stdlib/*.o
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
	$(RM) -f zx81/chroma81/*.o
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

# Math48
math48.lib:
	@echo ''
	@echo '--- Building Z80 math48 Library ---'
	@echo ''
	$(MAKE) -C math/math48

# Z88 maths build - dom
z88_math.lib:
	@echo ''
	@echo '--- Building Z88 Maths Library ---'
	@echo ''
	$(MAKE) -C math/z88math

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
	$(MAKE) -C fcntl/gen_rnd

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


# ZSock API (wrappers to package calls) - dom
net.lib:
	@echo ''
	@echo '--- Building Z88 ZSock Library ---'
	@echo ''
	$(MAKE) -C net 

# z88 library - dom
z88_clib.lib: gfxdeps
	@echo ''
	@echo '--- Building Z88 Library ---'
	@echo ''
	$(MAKE) -C fcntl/z88
	$(MAKE) -C stdio 
	$(MAKE) -C stdlib TARGET=z88
	$(MAKE) -C strings 
	$(MAKE) -C regex
	$(MAKE) -C time
	$(MAKE) -C rs232 lz88
	$(MAKE) -C setjmp
	$(MAKE) -C assert 
	$(MAKE) gamesdeps
	$(MAKE) -C games lz88 
	$(MAKE) -C z88 
	$(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz88 -x$(OUTPUT_DIRECTORY)/z88_clib @$(LISTFILE_DIRECTORY)/z88.lst

# Network stdio - dom
z88net_clib.lib: gfxdeps
	@echo ''
	@echo '--- Building Z88 Network Aware Library ---'
	@echo ''
	$(MAKE) -C fcntl/z88
	$(MAKE) -C stdio 
	$(MAKE) -C stdlib TARGET=z88
	$(MAKE) -C strings 
	$(MAKE) -C regex
	$(MAKE) -C time
	$(MAKE) -C rs232 lz88
	$(MAKE) -C setjmp
	$(MAKE) -C assert 
	$(MAKE) gamesdeps
	$(MAKE) -C games lz88 
	$(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz88 -x$(OUTPUT_DIRECTORY)/z88net_clib @$(LISTFILE_DIRECTORY)/z88net.lst

# ZX Spectrum fcntl - dom/stefano
zxfcntl:
	@echo ''
	@echo '--- Building ZX Spectrum fcntl libraries ---'
	@echo ''
	$(MAKE) -C fcntl/spectrum

# 64/32 column library for ZX Spectrum - dom/stefano
# ansi flags
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
zx_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings 
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=zx
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C spectrum
	$(MAKE) -C psg
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zx_clib @$(LISTFILE_DIRECTORY)/zx.lst
	$(LIBLINKER) -DFORzx $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zxcpm @$(LISTFILE_DIRECTORY)/zxcpm.lst

# ZX Spectrum RS232 libraries - stefano
zx232:
	$(MAKE) -C rs232 lzx

# 64/32 column library for TS2068 - dom/stefano/alvin
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
ts2068_clib.lib:
	@echo ''
	@echo '--- Building TS2068 (Spectrum clone) Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=zx
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C time 
	$(MAKE) gamesdeps
	$(MAKE) -C spectrum
	$(MAKE) -C psg
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORzx -DFORts2068 -DSTANDARDESCAPECHARS -DA80COL -x$(OUTPUT_DIRECTORY)/ts2068_clib @$(LISTFILE_DIRECTORY)/ts2068.lst

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
	$(MAKE) -C fcntl/zxvgs
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

# PacMan lib - Stefano
pacman_clib.lib:
	@echo ''
	@echo '--- Building PacMan HW Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=pacman
	$(MAKE) -C stdio
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORpacman -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pacman_clib @$(LISTFILE_DIRECTORY)/pacman.lst

# Philips P2000 lib - Stefano
p2000_clib.lib:
	@echo ''
	@echo '--- Building Philips P2000 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=p2000
	$(MAKE) -C stdio
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lp2000
	$(LIBLINKER) -DFORp2000 -x$(OUTPUT_DIRECTORY)/p2000_clib @$(LISTFILE_DIRECTORY)/p2000.lst

# PC6001 lib - Stefano
pc6001_clib.lib:
	@echo ''
	@echo '--- Building PC6001 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=pc6001
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C psg
	$(LIBLINKER) -DFORpc6001 -x$(OUTPUT_DIRECTORY)/pc6001_clib @$(LISTFILE_DIRECTORY)/pc6001.lst

# Native for sprinter - dom
pps_clib.lib:
	@echo ''
	@echo '--- Building Sprinter Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=zx
	$(MAKE) -C stdio 
	$(MAKE) -C fcntl/sprinter
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C time 
	$(MAKE) gamesdeps
	$(MAKE) -C spectrum 
	$(MAKE) -C psg
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pps_clib @$(LISTFILE_DIRECTORY)/pps.lst

# Epson PX4 lib - Stefano	
px4.lib:
	@echo ''
	@echo '--- Building PX-4/HC-40 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORpx4 -x$(OUTPUT_DIRECTORY)/px4 @$(LISTFILE_DIRECTORY)/px4.lst

# Epson PX8 lib - Stefano	
px8.lib:
	@echo ''
	@echo '--- Building PX-8/Geneva Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORpx8 -x$(OUTPUT_DIRECTORY)/px8 @$(LISTFILE_DIRECTORY)/px8.lst

# VZ200/300 lib - Stefano
vz_clib.lib:
	@echo ''
	@echo '--- Building VZ200/300 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=vz
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lvz
	$(LIBLINKER) -DFORvz -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/vz_clib @$(LISTFILE_DIRECTORY)/vz200.lst

# ZX80 lib - Stefano
zx80_clib.lib:
	@echo ''
	@echo '--- Building ZX80 Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=zx80
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lzx
	$(MAKE) -C psg
	$(LIBLINKER) -DSTANDARDESCAPECHARS -DFORzx80 -x$(OUTPUT_DIRECTORY)/zx80_clib @$(LISTFILE_DIRECTORY)/zx80.lst
	$(MAKE) zx81deps

# ZX81 lib - Stefano
zx81_clib.lib:
	@echo ''
	@echo '--- Building ZX81 Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=zx81
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp generic_iy
	$(MAKE) -C assert generic_iy
	$(MAKE) gamesdeps
	$(MAKE) -C games lzx81
	$(MAKE) -C psg generic_iy
	$(LIBLINKER) --IXIY -DSTANDARDESCAPECHARS -DFORzx81 $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zx81_clib @$(LISTFILE_DIRECTORY)/zx81.lst
	$(MAKE) zx81deps

# Lambda 8300 lib - Stefano
lambda_clib.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=zx81
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp generic_iy
	$(MAKE) -C assert generic_iy
	$(MAKE) gamesdeps
	$(MAKE) -C games lzx81
	$(MAKE) -C psg generic_iy
	$(LIBLINKER) --IXIY -DSTANDARDESCAPECHARS -DFORlambda -x$(OUTPUT_DIRECTORY)/lambda_clib @$(LISTFILE_DIRECTORY)/zx81.lst
	$(MAKE) zx81deps

# ZX81 std graphics lib - Stefano
gfx81.lib:
	@echo ''
	@echo '--- Building ZX81 Standard Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORzx81 -x$(OUTPUT_DIRECTORY)/gfx81 @$(LISTFILE_DIRECTORY)/gfx81.lst
	$(MAKE) zx81deps

# Lambda 8300 graphics lib - Stefano
gfxlambda.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORlambda -x$(OUTPUT_DIRECTORY)/gfxlambda @$(LISTFILE_DIRECTORY)/gfx81.lst
	$(MAKE) zx81deps

# ZX81 UDG based graphics lib - Stefano
gfx81udg.lib:
	@echo ''
	@echo '--- Building ZX81 UDG based Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORzx81udg -x$(OUTPUT_DIRECTORY)/gfx81udg @$(LISTFILE_DIRECTORY)/gfx81udg.lst
	$(MAKE) zx81deps

# ZX81 HR graphics lib - Stefano
gfx81hr64.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (64 rows)  ---'
	@echo ''
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORzx81hr64 -x$(OUTPUT_DIRECTORY)/gfx81hr64 @$(LISTFILE_DIRECTORY)/gfx81hr.lst
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORzx81hr64 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx64 @$(LISTFILE_DIRECTORY)/gfx81arx.lst
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORzx81mt64 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt64 @$(LISTFILE_DIRECTORY)/gfx81mt.lst
	$(MAKE) zx81deps

gfx81hr192.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (192 rows)  ---'
	@echo ''
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORzx81hr192 -x$(OUTPUT_DIRECTORY)/gfx81hr192 @$(LISTFILE_DIRECTORY)/gfx81hr.lst
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORzx81hr192 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx192 @$(LISTFILE_DIRECTORY)/gfx81arx.lst
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORzx81mt192 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt192 @$(LISTFILE_DIRECTORY)/gfx81mt.lst
	$(MAKE) zx81deps
	$(LIBLINKER) --IXIY -DFORzx81g007 -DG007 -x$(OUTPUT_DIRECTORY)/gfx81g007 @$(LISTFILE_DIRECTORY)/gfx81g007.lst
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

# Lambda 8300 maths library - Stefano
mlambda.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Maths Library ---'
	@echo ''
	$(MAKE) -C math/zxmath mlambda

mlambda_tiny.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Tiny Maths Library ---'
	@echo ''
	$(MAKE) -C math/zxmath mlambda_tiny

# Texas Instrument's calculators: - stefano/henk
# almost the same lib code with different -D flag set
# that's why we force most of the lib code to be rebuilt (tideps.sh)
ti82_clib.lib:
	@echo ''
	@echo '--- Building TI82 Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=ti82
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti82 -DSTANDARDESCAPECHARS -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti82_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83_clib.lib:
	@echo ''
	@echo '--- Building TI83 Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=ti83
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti83 -DSTANDARDESCAPECHARS -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83p_clib.lib:
	@echo ''
	@echo '--- Building TI83+ Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=ti83
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti83p -DSTANDARDESCAPECHARS -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83p_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti85_clib.lib:
	@echo ''
	@echo '--- Building TI85 Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=ti85
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti85 -DSTANDARDESCAPECHARS -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti85_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti86_clib.lib:
	@echo ''
	@echo '--- Building TI86 Library ---'
	@echo ''
	$(MAKE) tideps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=ti86
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lticalc
	$(LIBLINKER) -DFORti86 -DSTANDARDESCAPECHARS -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti86_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

# vt100 C lib for the Sharp OZ family - stefano
# use -DPACKEDFONT for tiny 50->80 column modes
ozansi_clib.lib:
	@echo ''
	@echo '--- Building Sharp OZ family ANSI Library ---'
	@echo ''
	$(RM) -f stdio/ansi/oz/f_ansi_char.o
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=oz
	$(MAKE) -C stdio 
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
	$(MAKE) -C fcntl/cpm
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=cpm
	$(MAKE) -C stdio 
	$(MAKE) -C time 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm_clib @$(LISTFILE_DIRECTORY)/cpm.lst

# Sorcerer Exidy lib - Stefano
sorcerer_clib.lib:
	@echo ''
	@echo '--- Building Sorcerer Exidy Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=srr
	$(MAKE) -C stdio
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORsorcerer -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sorcerer_clib @$(LISTFILE_DIRECTORY)/sorcerer.lst

# Sharp MZ lib - Stefano
mz_clib.lib:
	@echo ''
	@echo '--- Building Sharp MZ Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=mz
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORmz -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/mz_clib @$(LISTFILE_DIRECTORY)/mz.lst

# ABC80 Library - Stefano
abc80_clib.lib:
	@echo ''
	@echo '--- Building ABC80 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=abc80
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER)  -DFORabc80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc80_clib @$(LISTFILE_DIRECTORY)/abc80.lst

# ABC800 library - Stefano
abc800_clib.lib:
	@echo ''
	@echo '--- Building ABC800 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=abc800
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc800_clib @$(LISTFILE_DIRECTORY)/abc800.lst

# Jupiter ACE library - Stefano
ace_clib.lib:
	@echo ''
	@echo '--- Building Jupiter Ace Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=ace
	$(MAKE) -C stdio
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C ace 
	$(MAKE) -C games lace
	$(LIBLINKER) -DFORjupiter -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/ace_clib.lib @$(LISTFILE_DIRECTORY)/ace.lst

# Mattel Aquarius library - Stefano
aquarius_clib.lib:
	@echo ''
	@echo '--- Building Mattel Aquarius Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=aquarius
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C psg
	$(MAKE) -C games laquarius 
	$(LIBLINKER) -DFORaquarius -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/aquarius_clib.lib @$(LISTFILE_DIRECTORY)/aquarius.lst
	
# Aussie Byte library - Stefano
aussie.lib:
	@echo ''
	@echo '--- Building Aussie Byte Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) gamesdeps
	$(MAKE) -C games laussie
	$(LIBLINKER) -DFORaussie -x$(OUTPUT_DIRECTORY)/aussie.lib @$(LISTFILE_DIRECTORY)/aussie.lst

# Applied Technology MicroBee library - Stefano
bee_clib.lib:
	@echo ''
	@echo '--- Building MicroBee Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=bee
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lbee
	$(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/bee_clib.lib @$(LISTFILE_DIRECTORY)/bee.lst

microbee.lib:
	@echo ''
	@echo '--- Building MicroBee Library (CP/M & graphics) ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) gamesdeps
	$(MAKE) -C games lbee
	$(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/microbee.lib @$(LISTFILE_DIRECTORY)/beecpm.lst
	$(LIBLINKER) -DFORbee -x$(OUTPUT_DIRECTORY)/gfxbee.lib @$(LISTFILE_DIRECTORY)/beegfx.lst
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORbeehr -x$(OUTPUT_DIRECTORY)/gfxbee640.lib @$(LISTFILE_DIRECTORY)/beegfxhr.lst
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORbeehr320 -x$(OUTPUT_DIRECTORY)/gfxbee320.lib @$(LISTFILE_DIRECTORY)/beegfxhr320.lst
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORbeehr512 -x$(OUTPUT_DIRECTORY)/gfxbee512.lib @$(LISTFILE_DIRECTORY)/beegfxhr512.lst

# Philips Videopac C7420 library - Stefano
c7420_clib.lib:
	@echo ''
	@echo '--- Building Philips Videopac C7420 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=c7420
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DSTANDARDESCAPECHARS -DFORc7420 -x$(OUTPUT_DIRECTORY)/c7420_clib.lib @$(LISTFILE_DIRECTORY)/c7420.lst

# Xircom REX 6000 library - Dominic
rex_clib.lib:
	@echo ''
	@echo '--- Building Xircom Rex Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=rex
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
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=sam
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C time 
	$(MAKE) gamesdeps
	$(MAKE) -C games lzx
	$(LIBLINKER) -DFORsam -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sam_clib @$(LISTFILE_DIRECTORY)/sam.lst

# Spectravideo SVI library - Stefano
svi_clib.lib:
	@echo ''
	@echo '--- Building Spectravideo Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=svi
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C games lmsx
	$(MAKE) -C msx
	$(MAKE) -C psg
	$(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsvi -x$(OUTPUT_DIRECTORY)/svi_clib @$(LISTFILE_DIRECTORY)/svi.lst

# MSX library - Stefano
msx_clib.lib:
	@echo ''
	@echo '--- Building MSX Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C fcntl/cpm
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=msx
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C games lmsx
	$(MAKE) -C msx
	$(MAKE) -C psg
	$(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/msx_clib @$(LISTFILE_DIRECTORY)/msx.lst

# MTX library - Stefano
mtx_clib.lib:
	@echo ''
	@echo '--- Building Memotech MTX Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=mtx
	$(MAKE) -C stdio
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
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=enterprise
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C time 
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
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=m5
	$(MAKE) -C stdio 
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
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=mc1000
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lmc1000
	$(MAKE) -C psg
	$(LIBLINKER) -DFORmc1000 $(COLDEFS) -x$(OUTPUT_DIRECTORY)/mc1000_clib @$(LISTFILE_DIRECTORY)/mc1000.lst

# NASCOM library - Stefano
nascom_clib.lib:
	@echo ''
	@echo '--- Building NASCOM Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=nascom
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORnascom -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/nascom_clib @$(LISTFILE_DIRECTORY)/nascom.lst
	
# Robotron Z1013 library - Stefano
z1013_clib.lib:
	@echo ''
	@echo '--- Building Robotron Z1013 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=z1013
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORz1013 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z1013_clib @$(LISTFILE_DIRECTORY)/z1013.lst

# Robotron KC85/1, Z9001 library - Stefano
z9001_clib.lib:
	@echo ''
	@echo '--- Building Robotron KC85/1, KC/87, Z9001 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=z9001
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lz9001
	$(LIBLINKER) -DFORz9001 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z9001_clib @$(LISTFILE_DIRECTORY)/z9001.lst
	@echo ''
	@echo '--- Building Z9001 Standard Graphics Libraires ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORz9001 -x$(OUTPUT_DIRECTORY)/gfx9001 @$(LISTFILE_DIRECTORY)/gfx9001.lst
	@echo ''
	@echo '--- Building Z9001 KRT High Resolution libraires ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORz9001krt -x$(OUTPUT_DIRECTORY)/gfx9001krt @$(LISTFILE_DIRECTORY)/gfx9001krt.lst

# Robotron HC900, KC85/2..KC85/5 library - Stefano
kc_clib.lib:
	@echo ''
	@echo '--- Building VEB Mikroelektronik KC85/2..5 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=kc
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -DFORkc -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/kc_clib @$(LISTFILE_DIRECTORY)/kc.lst

# Untested C lib for NC100 machines - dom
nc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad NC100 Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=nc
	$(MAKE) -C stdio 
	$(MAKE) -C fcntl/nc100
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
	$(MAKE) -C fcntl/cpc
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=cpc
	$(MAKE) -C stdio
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C rs232 lcpc
	$(MAKE) -C psg
	$(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcpc -x$(OUTPUT_DIRECTORY)/cpc_clib @$(LISTFILE_DIRECTORY)/cpc.lst
	$(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpccpm @$(LISTFILE_DIRECTORY)/cpccpm.lst

cpcfs.lib:
	@echo ''
	@echo '--- Building Amstrad CPC fcntl Library ---'
	@echo ''
	$(MAKE) -C fcntl/cpc

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
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=c128
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C c128
	$(MAKE) -C psg c128
	$(MAKE) gamesdeps
	$(MAKE) -C games lc128
	$(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128cpm @$(LISTFILE_DIRECTORY)/c128cpm.lst
	$(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128ansi_clib @$(LISTFILE_DIRECTORY)/c128ansi.lst

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
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=newbrain
	$(MAKE) -C stdio 
	$(MAKE) -C fcntl/newbrain
	$(MAKE) -C setjmp
	$(MAKE) -C time 
	$(MAKE) -C assert
	$(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/newbrain_clib @$(LISTFILE_DIRECTORY)/newbrain.lst
	$(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/nbcpm_clib @$(LISTFILE_DIRECTORY)/nbcpm.lst

# TIKI-100 library - Stefano
tiki100.lib:
	@echo ''
	@echo '--- Building TIKI-100 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C psg
	$(LIBLINKER) -DFORtiki100 -x$(OUTPUT_DIRECTORY)/tiki100 @$(LISTFILE_DIRECTORY)/tiki100.lst
	
# RCM2/3000 lib
rcmx000_clib.lib:
	@echo ''
	@echo '--- Building RCM2/3000 Library ---'
	@echo ''
	$(MAKE) -C strings clean
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=rcmx000
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	z80asm --RCMX000 -DFORrcmx000 -x$(OUTPUT_DIRECTORY)/rcmx000_clib @$(LISTFILE_DIRECTORY)/rcmx000.lst
	$(MAKE) -C strings clean

# embedded target - contributed by Daniel Wallner
embedded_clib.lib:
	@echo ''
	@echo '--- Building Embedded (ns16450) Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=embedded
	$(MAKE) -C stdio 
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
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=gal
	$(MAKE) -C stdio 
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
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=lynx
	$(MAKE) -C stdio 
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
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=sms
	$(MAKE) -C stdio 
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
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=sc3000
	$(MAKE) -C stdio 
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
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=test
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C time
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/test_clib @$(LISTFILE_DIRECTORY)/test.lst

# TRS 80 - stefano
trs80_clib.lib:
	@echo ''
	@echo '--- Building TRS 80 Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=trs80
	$(MAKE) -C stdio
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games ltrs80
	$(MAKE) -C psg
	$(LIBLINKER) -DFORtrs80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/trs80_clib @$(LISTFILE_DIRECTORY)/trs80.lst
	$(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/trs80cpm @$(LISTFILE_DIRECTORY)/trs80cpm.lst
	@echo ''
	@echo '--- Building TRS 80 GFX libraires ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/gfxtrs80 @$(LISTFILE_DIRECTORY)/gfxtrs80.lst
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFOReg2000 -x$(OUTPUT_DIRECTORY)/gfxeg2000 @$(LISTFILE_DIRECTORY)/gfxeg2000.lst

# Canon X-07 lib - Stefano
x07_clib.lib:
	@echo ''
	@echo '--- Building Canon X-07 Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=x07
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/x07_clib @$(LISTFILE_DIRECTORY)/x07.lst

# Sharp X1 (ANSI VT) - Karl Von Dyson (X1s.org)
x1ansi_clib.lib:
	@echo ''
	@echo '--- Building Sharp X1 ANSI Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=x1
	$(MAKE) -C stdio 
	$(MAKE) -C time 
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
	$(MAKE) gfxdeps
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=vg5k
	$(MAKE) -C stdio 
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) gamesdeps
	$(MAKE) -C games lvg5k
	$(LIBLINKER) -DFORvg5k -x$(OUTPUT_DIRECTORY)/vg5k_clib @$(LISTFILE_DIRECTORY)/vg5k.lst

# S-OS (The Sentinel) - Stefano
sos_clib.lib:
	@echo ''
	@echo '--- Building S-OS (The Sentinel) Library ---'
	@echo ''
	$(MAKE) -C strings
	$(MAKE) -C regex
	$(MAKE) -C stdlib TARGET=sos
	$(MAKE) -C stdio 
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
	$(MAKE) -C regex
	$(MAKE) stdldeps
	$(MAKE) -C stdlib TARGET=osca
	$(MAKE) -C stdio 
	$(MAKE) -C rs232 losca
	$(MAKE) -C setjmp
	$(MAKE) -C assert
	$(MAKE) -C sdcard clean
	$(MAKE) -C fcntl/osca
	$(LIBLINKER) -DFORosca -DSDHC_SUPPORT -x$(OUTPUT_DIRECTORY)/osca_clib.lib @$(LISTFILE_DIRECTORY)/osca.lst

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
	$(MAKE) -C cpm clean
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
	$(MAKE) -C rex clean
	$(MAKE) -C rs232 clean
	$(MAKE) -C setjmp clean
	$(MAKE) -C spectrum clean
	$(MAKE) -C stdio clean
	$(MAKE) -C stdlib clean
	$(MAKE) -C strings clean
	$(MAKE) -C regex clean
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
	$(RM) tiki100/*.o
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
	$(MAKE) -C math clean
	$(RM) *.lib
	$(RM) compress/zx7/*.o

install:
	cp $(OUTPUT_DIRECTORY)/*.lib ../lib/clibs

