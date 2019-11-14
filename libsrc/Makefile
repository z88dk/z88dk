#
# Ah, that'd be nice, a library makefile!
#
# Problems? Contact the person to blame(!) above the section
# for the library
#
# $Id: Makefile,v 1.265+ ...now on GIT $


include Make.config

# LIBRARIES not built by the global list below:
# - SP1 (build depends on customization and machine target, "make sp1" for options)

all: genlibs rs232libs z88libs tilibs zxlibs eplibs c128libs nclibs cpclibs \
	abc80_clib.lib abc800_clib.lib ace_clib.lib aquarius_clib.lib \
	aussie.lib bee_clib.lib microbee.lib c7420_clib.lib \
	cpm_clib.lib einstein.lib fp1100_clib.lib gal_clib.lib \
	g800_clib.lib m5_clib.lib mc1000_clib.lib \
	msx_clib.lib mtx_clib.lib mz_clib.lib mz2500_clib.lib x1_clib.lib \
	nascom_clib.lib  newbrain_clib.lib \
	osca_clib.lib ozansi_clib.lib pacman_clib.lib p2000_clib.lib  \
	pc6001_clib.lib pc88_clib.lib pps_clib.lib px4.lib px8.lib \
	rex_clib.lib rx78_clib.lib sc3000_clib.lib sms_clib.lib lynx_clib.lib \
	svi_clib.lib sam_clib.lib  sorcerer_clib.lib  sos_clib.lib tiki100.lib \
	trs80_clib.lib trsdos.lib vg5k_clib.lib vz_clib.lib  x07_clib.lib \
	embedded_clib.lib test_clib.lib test8080_clib.lib testrcm_clib.lib testgbz80_clib.lib z1013_clib.lib z9001_clib.lib kc_clib.lib \
	pv1000_clib.lib pv2000_clib.lib coleco_clib.lib multi8_clib.lib alphatro_clib.lib  spc1000_clib.lib \
	laser500_clib.lib super80_clib.lib super80_vduem_clib.lib \
	adam.lib z80tvgame_clib.lib smc777.lib pasopia7_clib.lib sv8000_clib.lib \
	excali64_clib.lib gb_clib.lib s1mp3_clib.lib bic.lib \
	preempt.lib zx80_clib.lib zx81libs sp1-all rcmx000_clib.lib 

genlibs: z80_crt0.lib math48.lib gen_math.lib mbf32.lib mbf64.lib math32.lib gendos.lib ndos.lib  \
	 lib3d.lib x11.lib fastmath.lib

c128libs: c128ansi_clib.lib gfx128.lib gfx128hr.lib gfx128hr480.lib 

nclibs: nc_clib.lib gfxnc100.lib gfxzcn.lib gfxnc200.lib

eplibs: enterprise_clib.lib gfxep.lib gfxephr.lib

cpclibs: cpc_clib.lib  cpcfs.lib cpc_math.lib

z88libs: z88_math.lib  z88_clib.lib   

tilibs: ti82_clib.lib ti83_clib.lib ti83p_clib.lib ti85_clib.lib ti86_clib.lib

zxlibs: ts2068_clib.lib gfx2068hr.lib gfxspectrum.lib zx_clib.lib zxvgs.lib mzx.lib mzx_tiny.lib m2068.lib zxrom.lib zxfcntl

zx81libs: zx81_clib.lib gfx81.lib gfxlambda.lib gfx81udg.lib gfx81hr64.lib gfx81hr192.lib m81.lib m81_tiny.lib mlambda.lib mlambda_tiny.lib lambda_clib.lib

# moving external shell scripts to makefile to make life easy on
# the windows platform devs (ie Me :-) -- gamesdeps.sh, gfxdeps.sh, tideps.sh


define buildgeneric
	$(MAKE) -C ctype
	$(MAKE) -C strings
	$(MAKE) -C interrupts
	$(MAKE) -C regex
	$(MAKE) -C stdio
	$(MAKE) -C setjmp
	$(MAKE) -C time
	$(MAKE) -C debug
	$(MAKE) -C assert
	$(MAKE) -C font
	$(MAKE) -C stdlib TARGET=$(1)
	$(MAKE) -C compress/zx7
	$(MAKE) -C psg
	$(MAKE) -C alloc
	$(MAKE) -C debug
	$(MAKE) -C adt
	$(MAKE) -C adt-newlib
	$(MAKE) -C algorithm
	$(MAKE) -C rect
	$(MAKE) -C arch
endef

#  short script to sort out gfx dependencies
gfxdeps:
	@$(RM) -f graphics/*.o
	@$(RM) -f graphics/*/*.o

#  short script to sort out ticalc dependencies
tideps:
	@$(RM) -f stdio/ticalc/*.o
	@$(RM) -f stdio/ansi/ticalc/*.o
	@$(RM) -f games/*.o
	@$(RM) -f games/ticalc/*.o
	@$(RM) -f graphics/*.o
	@$(RM) -f graphics/*/*.o
	@$(RM) -f graphics/ticalc/*.o
	@$(RM) -f graphics/gray/*.o
	@$(RM) -f graphics/gray/ticalc/*.o

#  short script to sort out ticalc dependencies
msxdeps:
	@$(RM) -f stdio/msx/*.o
	@$(RM) -f stdio/tms9918/*.o
	@$(RM) -f stdio/ansi/msx/*.o
	@$(RM) -f games/*.o
	@$(RM) -f games/msx/*.o
	@$(RM) -f graphics/*.o
	@$(RM) -f graphics/*/*.o
	@$(RM) -f psg/msx/*.o
	@$(RM) -f psg/sn76489/*.o
	@$(RM) -f time/msx/*.o

zx81deps:
	@$(RM) -f stdio/zx81/*.o
	@$(RM) -f stdio/ansi/zx81/*.o
	@$(RM) -f stdio/ansi/zx81/text/*.o
	@$(RM) -f input/spectrum/*.o
	@$(RM) -f input/zx81/*.o
	@$(RM) -f games/zx81/*.o
	@$(RM) -f graphics/*.o
	@$(RM) -f graphics/*/*.o
	@$(RM) -f graphics/zx81/*.o
	@$(RM) -f graphics/zx81/hr/*.o
	@$(RM) -f graphics/zx81/udg/*.o
	@$(RM) -f graphics/gray/*.o
	@$(RM) -f target/zx81/*.o
	@$(RM) -f target/zx81/tape/*.o
	@$(RM) -f target/zx81/basic/*.o
	@$(RM) -f target/zx81/chroma81/*.o
	@$(RM) -f time/zx81/*.o


# Generic maths build - dom, stefano
gen_math.lib:
	@echo ''
	@echo '--- Building Z80 Generic Maths Library ---'
	@echo ''
	$(MAKE) -C math/genmath

mbf32.lib:
	@echo ''
	@echo '--- Building Microsoft Single Precision Maths Library ---'
	@echo ''
	$(MAKE) -C math/mbf32

# math32 build - @feilipu
math32.lib:
	@echo ''
	@echo '--- Building IEEE Single Precision Maths Library ---'
	@echo ''
	$(MAKE) -C math/math32

mbf64.lib:
	@echo ''
	@echo '--- Building Microsoft Double Precision Maths Library ---'
	@echo ''
	$(MAKE) -C math/mbf64


fastmath.lib:
	@echo ''
	@echo '--- Building fast integer maths library ---'
	@echo ''
	$(MAKE) -C math/fastmath

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

# z88 library - dom
z88_clib.lib:
	@echo ''
	@echo '--- Building Z88 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,z88)
	$(MAKE) -C games TARGET=z88
	$(MAKE) -C rs232/z88
	$(MAKE) -C target/z88
	TARGET=z88 TYPE=z80 $(LIBLINKER) -I$(Z88DK_LIB)/target/z88/def -DSTANDARDESCAPECHARS -DFORz88 -x$(OUTPUT_DIRECTORY)/z88_clib @$(LISTFILE_DIRECTORY)/z88.lst

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
	$(RM) stdio/spectrum/*.o
	$(MAKE) gfxdeps
	$(call buildgeneric,zx)
	$(MAKE) -C target/zx
	$(MAKE) -C games TARGET=zx
	TARGET=zx TYPE=z80 $(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zx_clib @$(LISTFILE_DIRECTORY)/zx.lst
	TARGET=zx TYPE=z80 $(LIBLINKER) -DFORzx $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zxcpm @$(LISTFILE_DIRECTORY)/zxcpm.lst

# Various RS232 libraries
rs232libs:
	@echo ''
	@echo '---> Building RS232 libraries <---'
	@echo ''
	$(MAKE) -C rs232

# 64/32 column library for TS2068 - dom/stefano/alvin
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
ts2068_clib.lib:
	@echo ''
	@echo '--- Building TS2068 (Spectrum clone) Library ---'
	@echo ''
	$(RM) stdio/spectrum/*.o
	$(MAKE) gfxdeps
	$(call buildgeneric,zx)
	$(MAKE) -C target/zx
	$(MAKE) -C games TARGET=zx
	$(RM) -f stdio/zx/*.o
	TARGET=zx TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORzx -DFORts2068 -DA80COL -x$(OUTPUT_DIRECTORY)/ts2068_clib @$(LISTFILE_DIRECTORY)/ts2068.lst

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
	TARGET=zx TYPE=z80 $(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/gfxspectrum @$(LISTFILE_DIRECTORY)/gfxspectrum.lst

# ZXROM - stefano
zxrom.lib:
	@echo ''
	@echo '--- Building ZXROM Library ---'
	@echo ''
	$(RM) stdio/spectrum/generic_console_scrollup.o
	$(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS -DNOROMCALLS -x$(OUTPUT_DIRECTORY)/zxrom @$(LISTFILE_DIRECTORY)/zxrom.lst
	$(RM) stdio/spectrum/generic_console_scrollup.o

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

# TS2068 maths library - Stefano
m2068.lib:
	@echo ''
	@echo '--- Building Timex TS2068 Maths Library ---'
	@echo ''
	$(MAKE) -C math/zxmath m2068

# PacMan lib - Stefano
pacman_clib.lib:
	@echo ''
	@echo '--- Building PacMan HW Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,pacman)
	TARGET=pacman TYPE=z80 $(LIBLINKER) -DFORpacman -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pacman_clib @$(LISTFILE_DIRECTORY)/pacman.lst

# Philips P2000 lib - Stefano
p2000_clib.lib:
	@echo ''
	@echo '--- Building Philips P2000 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,p2000)
	$(MAKE) -C games TARGET=p2000
	TARGET=p2000 TYPE=z80 $(LIBLINKER) -DFORp2000 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/p2000_clib @$(LISTFILE_DIRECTORY)/p2000.lst

# PC6001 lib - Stefano
pc6001_clib.lib:
	@echo ''
	@echo '--- Building PC6001 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,pc6001)
	$(MAKE) -C games TARGET=pc6001
	TARGET=pc6001 TYPE=z80 $(LIBLINKER) -DFORpc6001 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc6001_clib @$(LISTFILE_DIRECTORY)/pc6001.lst
	
# PC8801 lib - Stefano
pc88_clib.lib:
	@echo ''
	@echo '--- Building PC8801 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C psg
	$(call buildgeneric,pc88)
	$(MAKE) -C games TARGET=pc88
	TARGET=pc88 TYPE=z80 $(LIBLINKER) -DFORpc88 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc88_clib @$(LISTFILE_DIRECTORY)/pc88.lst
	@echo ''
	@echo '--- Building PC8801 160x100 graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=pc88 TYPE=z80 $(LIBLINKER) -DFORpc88 -x$(OUTPUT_DIRECTORY)/gfxpc88 @$(LISTFILE_DIRECTORY)/gfxpc88.lst
	@echo ''
	@echo '--- Building PC8801 640x200 Mono Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=pc88 TYPE=z80 $(LIBLINKER) -DFORpc88hr200 -x$(OUTPUT_DIRECTORY)/gfxpc88hr200 @$(LISTFILE_DIRECTORY)/gfxpc88hr200.lst

# Native for sprinter - dom
pps_clib.lib:
	@echo ''
	@echo '--- Building Sprinter Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,pps)
	$(MAKE) -C fcntl/sprinter
	$(MAKE) -C target/zx
	$(MAKE) -C games TARGET=pps
	TARGET=pps TYPE=z80 $(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pps_clib @$(LISTFILE_DIRECTORY)/pps.lst

# Epson PX4 lib - Stefano	
px4.lib:
	@echo ''
	@echo '--- Building PX-4/HC-40 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=px4 TYPE=z80 $(LIBLINKER) -DFORpx4 -x$(OUTPUT_DIRECTORY)/px4 @$(LISTFILE_DIRECTORY)/px4.lst

# Epson PX8 lib - Stefano	
px8.lib:
	@echo ''
	@echo '--- Building PX-8/Geneva Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=px8 TYPE=z80 $(LIBLINKER) -DFORpx8 -x$(OUTPUT_DIRECTORY)/px8 @$(LISTFILE_DIRECTORY)/px8.lst

# VZ200/300 lib - Stefano
vz_clib.lib:
	@echo ''
	@echo '--- Building VZ200/300 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,vz)
	$(MAKE) -C games TARGET=vz
	TARGET=vz TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORvz -x$(OUTPUT_DIRECTORY)/vz_clib @$(LISTFILE_DIRECTORY)/vz200.lst


# ZX80 lib - Stefano
zx80_clib.lib:
	@echo ''
	@echo '--- Building ZX80 Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(call buildgeneric,zx80)
	$(MAKE) -C games TARGET=zx80
	TARGET=zx80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORzx80 -x$(OUTPUT_DIRECTORY)/zx80_clib @$(LISTFILE_DIRECTORY)/zx80.lst
	$(MAKE) zx81deps

# ZX81 lib - Stefano
zx81_clib.lib:
	@echo ''
	@echo '--- Building ZX81 Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(call buildgeneric,zx81)
	$(MAKE) -C games TARGET=zx81
	TARGET=zx81 TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS --IXIY -DFORzx81 $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zx81_clib @$(LISTFILE_DIRECTORY)/zx81.lst
	$(MAKE) zx81deps

# Lambda 8300 lib - Stefano
lambda_clib.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(call buildgeneric,zx81)
	$(MAKE) -C games TARGET=zx81
	TARGET=zx81 SUBTARGET=lambda TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS --IXIY -DFORlambda -x$(OUTPUT_DIRECTORY)/lambda_clib @$(LISTFILE_DIRECTORY)/zx81.lst
	$(MAKE) zx81deps

# ZX81 std graphics lib - Stefano
gfx81.lib:
	@echo ''
	@echo '--- Building ZX81 Standard Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	TARGET=zx81 TYPE=ixiy $(LIBLINKER) --IXIY -DFORzx81 -x$(OUTPUT_DIRECTORY)/gfx81 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81.lst
	$(MAKE) zx81deps

# Lambda 8300 graphics lib - Stefano
gfxlambda.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	TARGET=lambda TYPE=ixiy $(LIBLINKER) --IXIY -DFORlambda -x$(OUTPUT_DIRECTORY)/gfxlambda @$(LISTFILE_DIRECTORY)/target/zx81/gfx81.lst
	$(MAKE) zx81deps

# ZX81 UDG based graphics lib - Stefano
gfx81udg.lib:
	@echo ''
	@echo '--- Building ZX81 UDG based Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	TYPE=zx81 SUBTARGET=zx81udg TYPE=ixiy $(LIBLINKER) --IXIY -DFORzx81udg -x$(OUTPUT_DIRECTORY)/gfx81udg @$(LISTFILE_DIRECTORY)/target/zx81/gfx81udg.lst
	$(MAKE) zx81deps

# ZX81 HR graphics lib - Stefano
gfx81hr64.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (64 rows)  ---'
	@echo ''
	$(MAKE) zx81deps
	TARGET=zx81 SUBTARGET=hr64 TYPE=ixiy $(LIBLINKER) --IXIY -DFORzx81hr64 -x$(OUTPUT_DIRECTORY)/gfx81hr64 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81hr.lst
	$(MAKE) zx81deps
	TARGET=zx81 SUBTARGET=arx TYPE=ixiy $(LIBLINKER) --IXIY -DFORzx81hr64 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx64 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81arx.lst
	$(MAKE) zx81deps
	TARGET=zx81 SUBTARGET=mt64 TYPE=ixiy $(LIBLINKER) --IXIY -DFORzx81mt64 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt64 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81mt.lst
	$(MAKE) zx81deps

gfx81hr192.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (192 rows)  ---'
	@echo ''
	$(MAKE) zx81deps
	TARGET=zx81 SUBTARGET=hr192 TYPE=ixiy $(LIBLINKER) --IXIY -DFORzx81hr192 -x$(OUTPUT_DIRECTORY)/gfx81hr192 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81hr.lst
	$(MAKE) zx81deps
	TARGET=zx81 SUBTARGET=arx192 TYPE=ixiy $(LIBLINKER) --IXIY -DFORzx81hr192 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx192 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81arx.lst
	$(MAKE) zx81deps
	TARGET=zx81 SUBTARGET=mt192 TYPE=ixiy $(LIBLINKER) --IXIY -DFORzx81mt192 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt192 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81mt.lst
	$(MAKE) zx81deps
	TARGET=zx81 SUBTARGET=g007 TYPE=ixiy $(LIBLINKER) --IXIY -DFORzx81g007 -DG007 -x$(OUTPUT_DIRECTORY)/gfx81g007 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81g007.lst
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
	$(call buildgeneric,ti82)
	$(RM) games/ticalc/*.o
	$(MAKE) -C games TARGET=ti82
	TARGET=ti82 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti82 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti82_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83_clib.lib:
	@echo ''
	@echo '--- Building TI83 Library ---'
	@echo ''
	$(MAKE) tideps
	$(call buildgeneric,ti83)
	$(RM) -f games/ticalc/*.o
	$(MAKE) -C games TARGET=ti83
	TARGET=ti83 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti83 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83p_clib.lib:
	@echo ''
	@echo '--- Building TI83+ Library ---'
	@echo ''
	$(MAKE) tideps
	$(call buildgeneric,ti8x)
	$(RM) -f games/ticalc/*.o
	$(MAKE) -C games TARGET=ti8x
	TARGET=ti8x TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti83p -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83p_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti85_clib.lib:
	@echo ''
	@echo '--- Building TI85 Library ---'
	@echo ''
	$(MAKE) tideps
	$(call buildgeneric,ti85)
	$(RM) -f games/ticalc/*.o
	$(MAKE) -C games TARGET=ti85
	TARGET=ti85 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti85 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti85_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti86_clib.lib:
	@echo ''
	@echo '--- Building TI86 Library ---'
	@echo ''
	$(MAKE) tideps
	$(call buildgeneric,ti86)
	$(RM) -f games/ticalc/*.o
	$(MAKE) -C games TARGET=ti86
	TARGET=ti86 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti86 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti86_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

# vt100 C lib for the Sharp OZ family - stefano
# use -DPACKEDFONT for tiny 50->80 column modes
ozansi_clib.lib:
	@echo ''
	@echo '--- Building Sharp OZ family ANSI Library ---'
	@echo ''
	$(RM) -f stdio/ansi/oz/f_ansi_char.o
	$(MAKE) gfxdeps
	$(call buildgeneric,oz)
	$(MAKE) -C oz 
	$(MAKE) -C games TARGET=oz
	TARGET=oz TYPE=z80 $(LIBLINKER) -DFORoz -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ozansi_clib @$(LISTFILE_DIRECTORY)/ozansi.lst

# CPM lib - Stefano/dom
cpm_clib.lib:
	@echo ''
	@echo '--- Building CP/M Library ---'
	@echo ''
	$(call buildgeneric,cpm)
	$(MAKE) -C fcntl/cpm
	TARGET=cpm TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm_clib @$(LISTFILE_DIRECTORY)/cpm.lst
	@echo ''
	@echo '--- Building CP/M Library (8080)---'
	@echo ''
	TARGET=cpm TYPE=8080 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm8080_clib @$(LISTFILE_DIRECTORY)/cpm_8080.lst
	@echo ''
	@echo '--- Building CP/M Device fnctl Library ---'
	@echo ''
	TARGET=cpm TYPE=z80 DEVICE=device $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpmdevice @fcntl/cpm/fcntl.lst
	@echo ''
	@echo '--- Building CP/M Device fnctl Library (8080) ---'
	@echo ''
	TARGET=cpm TYPE=8080 DEVICE=device $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpmdevice @fcntl/cpm/fcntl.lst
	@echo ''
	@echo '--- Building Kaypro graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=kaypro TYPE=z80 $(LIBLINKER) -DFORkaypro -x$(OUTPUT_DIRECTORY)/gfxkp @$(LISTFILE_DIRECTORY)/gfxkp.lst
	$(MAKE) gfxdeps
	TARGET=kaypro SUBTARGET=kaypro83 TYPE=z80 $(LIBLINKER) -DFORkaypro83 -I$(Z88DK_LIB) -x$(OUTPUT_DIRECTORY)/gfxkp83 @$(LISTFILE_DIRECTORY)/target/kaypro83/gfxkp83.lst
	@echo ''
	@echo '--- Building Otrona Attache Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C psg
	TARGET=attache TYPE=z80 $(LIBLINKER) -DFORattache -x$(OUTPUT_DIRECTORY)/gfxattache @$(LISTFILE_DIRECTORY)/gfxattache.lst
	TYPE=z80 $(LIBLINKER) -DFORattache -x$(OUTPUT_DIRECTORY)/attache @$(LISTFILE_DIRECTORY)/attache.lst
	@echo ''
	@echo '--- Building Osborne 1 graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=osborne1 TYPE=z80 $(LIBLINKER) -DFORosborne1 -x$(OUTPUT_DIRECTORY)/gfxosborne1 @$(LISTFILE_DIRECTORY)/gfxosborne1.lst
	@echo ''
	@echo '--- Building RC-700 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=rc700 TYPE=z80 $(LIBLINKER) -DFORrc700 -x$(OUTPUT_DIRECTORY)/rc700 @$(LISTFILE_DIRECTORY)/target/rc700/rc700.lst
	@echo ''
	@echo '--- Building Sharp X1 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C target/x1 
	TARGET=x1 TYPE=z80 $(LIBLINKER) -DFORx1 -x$(OUTPUT_DIRECTORY)/x1_cpm @$(LISTFILE_DIRECTORY)/target/x1/x1_cpm.lst


# Sorcerer Exidy lib - Stefano
sorcerer_clib.lib:
	@echo ''
	@echo '--- Building Sorcerer Exidy Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,srr)
	$(MAKE) -C games TARGET=srr
	TARGET=srr TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsorcerer -x$(OUTPUT_DIRECTORY)/sorcerer_clib @$(LISTFILE_DIRECTORY)/sorcerer.lst

# Sharp MZ lib - Stefano
mz_clib.lib:
	@echo ''
	@echo '--- Building Sharp MZ Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=mz
	$(call buildgeneric,mz)
	TARGET=mz TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmz -x$(OUTPUT_DIRECTORY)/mz_clib @$(LISTFILE_DIRECTORY)/mz.lst

# Sharp MZ2500 lib - Stefano
mz2500_clib.lib:
	@echo ''
	@echo '--- Building Sharp MZ-2500 Library ---'
	@echo ''
	$(call buildgeneric,mz2500)
	TARGET=mz2500 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmz2500 -x$(OUTPUT_DIRECTORY)/mz2500_clib @$(LISTFILE_DIRECTORY)/mz2500.lst

# ABC80 Library - Stefano
abc80_clib.lib:
	@echo ''
	@echo '--- Building ABC80 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,abc80)
	$(MAKE) -C games TARGET=abc80 SUBSET=joystick.asm
	TARGET=abc80 TYPE=z80 $(LIBLINKER)  -DFORabc80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc80_clib @$(LISTFILE_DIRECTORY)/abc80.lst

# ABC800 library - Stefano
abc800_clib.lib:
	@echo ''
	@echo '--- Building ABC800 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,abc800)
	$(MAKE) -C games TARGET=abc800 SUBSET=joystick.asm
	TARGET=abc800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc800_clib @$(LISTFILE_DIRECTORY)/abc800.lst

# Jupiter ACE library - Stefano
ace_clib.lib:
	@echo ''
	@echo '--- Building Jupiter Ace Library ---'
	@echo ''
	$(call buildgeneric,ace)
	$(MAKE) -C ace 
	$(MAKE) -C games TARGET=ace
	TARGET=ace TYPE=z80 $(LIBLINKER) -DFORace -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/ace_clib.lib @$(LISTFILE_DIRECTORY)/ace.lst
	@echo ''
	@echo '--- Building Jupiter Ace Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=ace TYPE=z80 $(LIBLINKER) -DFORace -x$(OUTPUT_DIRECTORY)/gfxace @$(LISTFILE_DIRECTORY)/gfxace.lst
	@echo ''
	@echo '--- Building Jupiter Ace UDG based Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=aceudg TYPE=z80 $(LIBLINKER) -DFORaceudg -x$(OUTPUT_DIRECTORY)/gfxaceudg @$(LISTFILE_DIRECTORY)/gfxaceudg.lst

# Mattel Aquarius library - Stefano
aquarius_clib.lib:
	@echo ''
	@echo '--- Building Mattel Aquarius Library (& 80x72 GFX) ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,aquarius)
	$(MAKE) -C games TARGET=aquarius 
	TARGET=aquarius TYPE=z80 $(LIBLINKER) -DFORaquarius -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/aquarius_clib.lib @$(LISTFILE_DIRECTORY)/aquarius.lst
	@echo ''
	@echo '--- Building Mattel Aquarius 80x48 Graphics lib ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=aquarius TYPE=z80 $(LIBLINKER) -DFORaq48 -x$(OUTPUT_DIRECTORY)/gfxaq48 @$(LISTFILE_DIRECTORY)/gfxaq48.lst
	
# Aussie Byte library - Stefano
aussie.lib:
	@echo ''
	@echo '--- Building Aussie Byte Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C games TARGET=cpm SUBTYPE=aussie
	TARGET=aussie TYPE=z80 $(LIBLINKER) -DFORaussie -x$(OUTPUT_DIRECTORY)/aussie.lib @$(LISTFILE_DIRECTORY)/aussie.lst

# Applied Technology MicroBee library - Stefano
bee_clib.lib:
	@echo ''
	@echo '--- Building MicroBee Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,bee)
	$(MAKE) -C games TARGET=bee
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/bee_clib.lib @$(LISTFILE_DIRECTORY)/bee.lst

microbee.lib:
	@echo ''
	@echo '--- Building MicroBee Library (CP/M & graphics) ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C games TARGET=bee
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/microbee.lib @$(LISTFILE_DIRECTORY)/beecpm.lst
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -x$(OUTPUT_DIRECTORY)/gfxbee.lib @$(LISTFILE_DIRECTORY)/beegfx.lst
	$(MAKE) gfxdeps
	TARGET=bee SUBTARGET=hr TYPE=z80 $(LIBLINKER) -DFORbeehr -x$(OUTPUT_DIRECTORY)/gfxbee640.lib @$(LISTFILE_DIRECTORY)/beegfxhr.lst
	$(MAKE) gfxdeps
	TARGET=bee SUBTARGET=hr320 TYPE=z80 $(LIBLINKER) -DFORbeehr320 -x$(OUTPUT_DIRECTORY)/gfxbee320.lib @$(LISTFILE_DIRECTORY)/beegfxhr320.lst
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORbeehr512 -x$(OUTPUT_DIRECTORY)/gfxbee512.lib @$(LISTFILE_DIRECTORY)/beegfxhr512.lst

# Philips Videopac C7420 library - Stefano
c7420_clib.lib:
	@echo ''
	@echo '--- Building Philips Videopac C7420 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,c7420)
	TARGET=c7420 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORc7420 -x$(OUTPUT_DIRECTORY)/c7420_clib.lib @$(LISTFILE_DIRECTORY)/c7420.lst

# Xircom REX 6000 library - Dominic
rex_clib.lib:
	@echo ''
	@echo '--- Building Xircom Rex Library ---'
	@echo ''
	$(call buildgeneric,rex)
	$(MAKE) -C target/rex
	TARGET=rex TYPE=z80 $(LIBLINKER) -DFORrex -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/rex_clib.lib @$(LISTFILE_DIRECTORY)/rex6000.lst

# Sam Coupe library - Stefano & Frode
sam_clib.lib:
	@echo ''
	@echo '--- Building Sam Coupe Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,sam)
	$(MAKE) -C games TARGET=sam
	$(MAKE) -C target/zx
	TARGET=sam TYPE=z80 $(LIBLINKER) -DFORsam -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sam_clib @$(LISTFILE_DIRECTORY)/sam.lst

# Spectravideo SVI library - Stefano
svi_clib.lib:
	@echo ''
	@echo '--- Building Spectravideo Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(call buildgeneric,svi)
	$(RM) games/msx/*.o
	$(MAKE) -C games TARGET=svi
	$(MAKE) -C target/msx/msxbios
	$(MAKE) -C target/svi TARGET=svi
	$(MAKE) -C video/tms9918 TARGET=svi
	$(MAKE) -C psg
	$(MAKE) -C rs232/svi
	TARGET=svi TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsvi -x$(OUTPUT_DIRECTORY)/svi_clib @$(LISTFILE_DIRECTORY)/svi.lst
	TARGET=svi TYPE=z80 $(LIBLINKER) -DFORsvi -x$(OUTPUT_DIRECTORY)/svibios @target/svi/arch_svibios.lst

# MSX library - Stefano
msx_clib.lib:
	@echo ''
	@echo '--- Building MSX Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(call buildgeneric,msx)
	$(MAKE) -C fcntl/cpm
	$(MAKE) -C fcntl/msxdos2
	$(RM) games/msx/*.o
	$(MAKE) -C games TARGET=msx
	$(MAKE) -C target/msx 
	$(MAKE) -C video/tms9918 TARGET=msx
	$(MAKE) -C psg
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/msx_clib @$(LISTFILE_DIRECTORY)/msx.lst
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/msxbios @target/msx/arch_msxbios.lst

# MTX library - Stefano
mtx_clib.lib:
	@echo ''
	@echo '--- Building Memotech MTX Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=mtx
	$(call buildgeneric,mtx)
	$(MAKE) -C games TARGET=mtx
	$(MAKE) -C video/tms9918 TARGET=mtx
	$(MAKE) -C rs232/mtx
	TARGET=mtx TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmtx -x$(OUTPUT_DIRECTORY)/mtx_clib @$(LISTFILE_DIRECTORY)/mtx.lst

# Enterprise library - Stefano
enterprise_clib.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,enterprise)
	$(MAKE) -C games TARGET=enterprise
	$(MAKE) -C enterprise 
	TARGET=enterprise TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORenterprise -x$(OUTPUT_DIRECTORY)/enterprise_clib @$(LISTFILE_DIRECTORY)/enterprise.lst

# Enterprise graphics lib - Stefano
gfxep.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C graphics lenterprise
	TARGET=enterprise TYPE=z80 $(LIBLINKER) -DFORenterprise -x$(OUTPUT_DIRECTORY)/gfxep @$(LISTFILE_DIRECTORY)/gfxep.lst

# Enterprise HRG graphics lib - Stefano
gfxephr.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 High Resolution Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C graphics lenterprisehr
	TARGET=enterprise SUBTARGET=enterprisehr TYPE=z80 $(LIBLINKER) -DFORenterprisehr -x$(OUTPUT_DIRECTORY)/gfxephr @$(LISTFILE_DIRECTORY)/gfxephr.lst

# Einstein library - Stefano
einstein.lib:
	@echo ''
	@echo '--- Building Tatung Einstein Library ---'
	@echo ''
	$(MAKE) msxdeps
	@$(RM) -f video/mc6845/*.o
	$(MAKE) -C games TARGET=cpm SUBTYPE=einstein
	$(MAKE) -C video/tms9918 TARGET=cpm SUBTYPE=einstein
	$(MAKE) -C psg
	TARGET=einstein TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFOReinstein -x$(OUTPUT_DIRECTORY)/einstein @$(LISTFILE_DIRECTORY)/einstein.lst

excali64_clib.lib:
	@echo ''
	@echo '--- Building Excalibur 64 Library ---'
	$(MAKE) gfxdeps
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,excali64)
	TARGET=excali64 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORexcali64 -x$(OUTPUT_DIRECTORY)/excali64_clib @$(LISTFILE_DIRECTORY)/excali64_clib.lst
	TARGET=excali64 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORexcali64 -x$(OUTPUT_DIRECTORY)/excali64 @$(LISTFILE_DIRECTORY)/excali64.lst

# SMC-777 library 
smc777.lib:
	@echo ''
	@echo '--- Building Sony SMC-70/SMC-777 Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(MAKE) -C psg
	$(MAKE) -C games TARGET=cpm SUBTYPE=smc777 TARGET_CFLAGS=-subtype=smc777
	TARGET=smc777 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsmc777 -x$(OUTPUT_DIRECTORY)/smc777 @$(LISTFILE_DIRECTORY)/smc777.lst

# A5105 library
bic.lib:
	@echo ''
	@echo '--- Building A5105 Library ---'
	@echo ''
	$(MAKE) -C video/upd7220 TARGET=bic
	TARGET=bic TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORbic -x$(OUTPUT_DIRECTORY)/bic @$(LISTFILE_DIRECTORY)/bic.lst




# Coleco Adam library 
adam.lib:
	@echo ''
	@echo '--- Building Coleco Adam Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=cpm SUBTYPE=coleco
	$(MAKE) -C video/tms9918 TARGET=coleco
	$(MAKE) -C psg
	TARGET=coleco TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -DFORadam -x$(OUTPUT_DIRECTORY)/adam @$(LISTFILE_DIRECTORY)/adam.lst

# SORD M5 library - Stefano
m5_clib.lib:
	@echo ''
	@echo '--- Building SORD M5 Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=m5
	$(call buildgeneric,m5)
	$(MAKE) -C video/tms9918 TARGET=m5
	TARGET=m5 TYPE=z80 $(LIBLINKER) -DFORm5 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/m5_clib @$(LISTFILE_DIRECTORY)/m5.lst

# MC-1000 library - Stefano
mc1000_clib.lib:
	@echo ''
	@echo '--- Building CCE MC-1000 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,mc1000)
	$(MAKE) -C games TARGET=mc1000
	TARGET=mc1000 TYPE=z80 $(LIBLINKER) -DFORmc1000 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/mc1000_clib @$(LISTFILE_DIRECTORY)/mc1000.lst

# NASCOM library - Stefano
nascom_clib.lib:
	@echo ''
	@echo '--- Building NASCOM Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,nascom)
	TARGET=nascom TYPE=z80 $(LIBLINKER) -DFORnascom -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/nascom_clib @$(LISTFILE_DIRECTORY)/nascom.lst
	
# Robotron Z1013 library - Stefano
z1013_clib.lib:
	@echo ''
	@echo '--- Building Robotron Z1013 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,z1013)
	TARGET=z1013 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz1013 -x$(OUTPUT_DIRECTORY)/z1013_clib @$(LISTFILE_DIRECTORY)/z1013.lst

# Robotron KC85/1, Z9001 library - Stefano
z9001_clib.lib:
	@echo ''
	@echo '--- Building Robotron KC85/1, KC/87, Z9001 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,z9001)
	$(MAKE) -C games TARGET=z9001
	TARGET=z9001 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz9001 -x$(OUTPUT_DIRECTORY)/z9001_clib @$(LISTFILE_DIRECTORY)/z9001.lst
	@echo ''
	@echo '--- Building Z9001 Standard Graphics Libraires ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=z9001 TYPE=z80 $(LIBLINKER) -DFORz9001 -x$(OUTPUT_DIRECTORY)/gfx9001 @$(LISTFILE_DIRECTORY)/gfx9001.lst
	@echo ''
	@echo '--- Building Z9001 KRT High Resolution libraires ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=z9001 SUBTARGET=z9001krt TYPE=z80 $(LIBLINKER) -DFORz9001krt -x$(OUTPUT_DIRECTORY)/gfx9001krt @$(LISTFILE_DIRECTORY)/gfx9001krt.lst

# Robotron HC900, KC85/2..KC85/5 library - Stefano
kc_clib.lib:
	@echo ''
	@echo '--- Building VEB Mikroelektronik KC85/2..5 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,kc)
	TARGET=kc TYPE=ixiy $(LIBLINKER) --IXIY -DSTANDARDESCAPECHARS -DFORkc -x$(OUTPUT_DIRECTORY)/kc_clib @$(LISTFILE_DIRECTORY)/kc.lst

# Bandai RX78 - dom
rx78_clib.lib:
	@echo ''
	@echo '--- Building Bandai RX78 Library ---'
	@echo ''
	@$(RM) -f psg/sn76489/*.o
	@$(RM) -f games/*.o
	$(MAKE) gfxdeps
	$(call buildgeneric,rx78)
	$(MAKE) -C games TARGET=rx78
	TARGET=rx78 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORrx78 -x$(OUTPUT_DIRECTORY)/rx78_clib @$(LISTFILE_DIRECTORY)/rx78.lst

# Casio FP-1100- dom
fp1100_clib.lib:
	@echo ''
	@echo '--- Building Casio FP-1100 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,fp1100)
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_clib @$(LISTFILE_DIRECTORY)/fp1100.lst

# Z80 TV Game
z80tvgame_clib.lib:
	@echo ''
	@echo '--- Building Z80 TV Game Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,z80tvgame)
	$(MAKE) -C games TARGET=z80tvgame
	TARGET=z80tvgame TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz80tvgame -x$(OUTPUT_DIRECTORY)/z80tvgame_clib @$(LISTFILE_DIRECTORY)/z80tvgame.lst


# Mitsubishi Multi8 - dom
multi8_clib.lib:
	@echo ''
	@echo '--- Building Mitsubishi Multi8 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,multi8)
	TARGET=multi8 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmulti8 -x$(OUTPUT_DIRECTORY)/multi8_clib @$(LISTFILE_DIRECTORY)/multi8.lst

# Pasopia7 Multi8 - dom
pasopia7_clib.lib:
	@echo ''
	@echo '--- Building Toshiba Pasopia7 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,pasopia7)
	$(MAKE) -C games TARGET=pasopia7
	TARGET=pasopia7 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpasopia7 -x$(OUTPUT_DIRECTORY)/pasopia7_clib @$(LISTFILE_DIRECTORY)/pasopia7.lst

# VTech VZ700- dom
laser500_clib.lib:
	@echo ''
	@echo '--- Building VTech Laser 350/500/700 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,laser500)
	$(MAKE) -C games TARGET=laser500
	TARGET=laser500 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORlaser500 -x$(OUTPUT_DIRECTORY)/laser500_clib @$(LISTFILE_DIRECTORY)/laser500.lst

# Dick Smith Super80 - dom
super80_clib.lib:
	@echo ''
	@echo '--- Building Super80 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,super80)
	$(MAKE) -C games TARGET=super80
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_clib @$(LISTFILE_DIRECTORY)/super80.lst

super80_vduem_clib.lib:
	@echo ''
	@echo '--- Building Super80 VDUEM Library ---'
	@echo ''
	$(MAKE) gfxdeps
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,super80)
	$(MAKE) -C games TARGET=super80
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_vduem_clib @$(LISTFILE_DIRECTORY)/super80_vduem.lst




# Triumph Adler Alphatronic PC - dom
alphatro_clib.lib:
	@echo ''
	@echo '--- Building Triump Adler Alphatronic PC Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(MAKE) gfxdeps
	$(call buildgeneric,alphatro)
	$(MAKE) -C games TARGET=alphatro
	TARGET=alphatro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORalphatro -x$(OUTPUT_DIRECTORY)/alphatro_clib @$(LISTFILE_DIRECTORY)/alphatro.lst

# SPC-1000 - dom
spc1000_clib.lib:
	@echo ''
	@echo '--- Building Samsung SPC-1000 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) msxdeps
	$(call buildgeneric,spc1000)
	$(MAKE) -C video/tms9918 TARGET=spc1000
	$(MAKE) -C games TARGET=spc1000
	TARGET=spc1000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORspc1000 -x$(OUTPUT_DIRECTORY)/spc1000_clib @$(LISTFILE_DIRECTORY)/spc1000.lst
	
# Casio PV1000 - dom
pv1000_clib.lib:
	@echo ''
	@echo '--- Building Casio PV-1000 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C games TARGET=pv1000
	$(call buildgeneric,pv1000)
	TARGET=pv1000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpv1000 -x$(OUTPUT_DIRECTORY)/pv1000_clib @$(LISTFILE_DIRECTORY)/pv1000.lst

# Casio PV2000 - dom/stefano
pv2000_clib.lib:
	@echo ''
	@echo '--- Building Casio PV-2000 Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=pv2000
	$(call buildgeneric,pv2000)
	$(MAKE) -C games TARGET=pv2000
	$(MAKE) -C video/tms9918 TARGET=pv2000
	TARGET=pv2000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpv2000 -x$(OUTPUT_DIRECTORY)/pv2000_clib @$(LISTFILE_DIRECTORY)/pv2000.lst

# Bandai Supervision 8000 - dom
sv8000_clib.lib:
	@echo ''
	@echo '--- Building Bandai Supervision 8000 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,sv8000)
	$(MAKE) -C games TARGET=sv8000
	TARGET=sv8000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsv8000 -x$(OUTPUT_DIRECTORY)/sv8000_clib @$(LISTFILE_DIRECTORY)/sv8000.lst

# Colecovision - dom/stefano
coleco_clib.lib:
	@echo ''
	@echo '--- Building Colecovision Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=coleco
	$(call buildgeneric,coleco)
	$(MAKE) -C games TARGET=coleco
	$(MAKE) -C video/tms9918 TARGET=coleco
	TARGET=coleco TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -x$(OUTPUT_DIRECTORY)/coleco_clib @$(LISTFILE_DIRECTORY)/coleco.lst

# Untested C lib for NC100 machines - dom
nc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad NC100 Library ---'
	@echo ''
	$(call buildgeneric,nc)
	$(MAKE) -C fcntl/nc100
	TARGET=nc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnc -x$(OUTPUT_DIRECTORY)/nc_clib @$(LISTFILE_DIRECTORY)/nc100.lst
	
# NC-100 graphics lib - Stefano
gfxnc100.lib:
	@echo ''
	@echo '--- Building NC-100 Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=nc TYPE=z80 $(LIBLINKER) -DFORnc100 -x$(OUTPUT_DIRECTORY)/gfxnc100 @$(LISTFILE_DIRECTORY)/gfxnc.lst
	
gfxzcn.lib:
	@echo ''
	@echo '--- Building NC-100 Graphics Library (ZCN)---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=nc SUBTARGET=zcn TYPE=z80 $(LIBLINKER) -DFORnc100 -DFORzcn -x$(OUTPUT_DIRECTORY)/gfxzcn @$(LISTFILE_DIRECTORY)/gfxnc.lst

# NC-200 graphics lib - Stefano
gfxnc200.lib:
	@echo ''
	@echo '--- Building NC-200 Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=nc SUBTARGET=nc200 TYPE=z80 $(LIBLINKER) -DFORnc200 -x$(OUTPUT_DIRECTORY)/gfxnc200 @$(LISTFILE_DIRECTORY)/gfxnc.lst

# Amstrad CPC library - Stefano
cpc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad CPC Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,cpc)
	$(MAKE) -C fcntl/cpc
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcpc -x$(OUTPUT_DIRECTORY)/cpc_clib @$(LISTFILE_DIRECTORY)/cpc.lst
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpccpm @$(LISTFILE_DIRECTORY)/cpccpm.lst

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
	$(call buildgeneric,c128)
	$(MAKE) -C target/c128
	$(MAKE) -C games TARGET=c128
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128cpm @$(LISTFILE_DIRECTORY)/c128cpm.lst
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128ansi_clib @$(LISTFILE_DIRECTORY)/c128ansi.lst

# C128 Base text mode graphics lib - Stefano
gfx128.lib:
	@echo ''
	@echo '--- Building Commodore 128 Base Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/gfx128 @$(LISTFILE_DIRECTORY)/gfx128.lst

# C128 HRG graphics lib - Stefano
gfx128hr.lib:
	@echo ''
	@echo '--- Building Commodore 128 High Resolution Graphics Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C graphics lc128
	TARGET=c128 SUBTARGET=128hr TYPE=z80 $(LIBLINKER) -DFORc128hr -x$(OUTPUT_DIRECTORY)/gfx128hr @$(LISTFILE_DIRECTORY)/gfx128hr.lst

# C128 640x480 HRG graphics lib - Stefano
gfx128hr480.lib:
	@echo ''
	@echo '--- Building Commodore 128 640x480 HRG Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(MAKE) -C graphics lc128
	TARGET=c128 SUBTARGET=128hr480 TYPE=z80 $(LIBLINKER) -DFORc128hr480 -x$(OUTPUT_DIRECTORY)/gfx128hr480 @$(LISTFILE_DIRECTORY)/gfx128hr480.lst

# Grundy NewBrain library - Stefano
newbrain_clib.lib:
	@echo ''
	@echo '--- Building Grundy NewBrain Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,newbrain)
	$(MAKE) -C fcntl/newbrain
	TARGET=newbrain TYPE=z80 $(LIBLINKER) -DFORnewbrain -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/newbrain_clib @$(LISTFILE_DIRECTORY)/newbrain.lst
	TARGET=newbrain TYPE=z80 $(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/nbcpm_clib @$(LISTFILE_DIRECTORY)/nbcpm.lst

# TIKI-100 library - Stefano
tiki100.lib:
	@echo ''
	@echo '--- Building TIKI-100 Library ---'
	@echo ''
	$(call buildgeneric,cpm)
	$(MAKE) gfxdeps
	$(MAKE) -C psg
	TARGET=tiki100 TYPE=z80 $(LIBLINKER) -DFORtiki100 -x$(OUTPUT_DIRECTORY)/tiki100 @$(LISTFILE_DIRECTORY)/tiki100.lst
	
# RCM2/3000 lib
rcmx000_clib.lib:
	@echo ''
	@echo '--- Building RCM2/3000 Library ---'
	@echo ''
	$(call buildgeneric,rcmx000)
	TARGET=rcmx000 TYPE=r2k $(LIBLINKER) -mr2k -DSTANDARDESCAPECHARS -DFORrcmx000 -x$(OUTPUT_DIRECTORY)/rcmx000_clib @$(LISTFILE_DIRECTORY)/rcmx000.lst

# embedded target - contributed by Daniel Wallner
embedded_clib.lib:
	@echo ''
	@echo '--- Building Embedded (ns16450) Library ---'
	@echo ''
	$(call buildgeneric,embedded)
	TARGET=embedded TYPE=z80 $(LIBLINKER) -DFORembedded -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/embedded_clib @$(LISTFILE_DIRECTORY)/embedded.lst

# Galaksija - Stefano Bodrato
gal_clib.lib:
	@echo ''
	@echo '--- Building Galaksija Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,gal)
	$(MAKE) -C games TARGET=gal
	TARGET=gal TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgal -x$(OUTPUT_DIRECTORY)/gal_clib @$(LISTFILE_DIRECTORY)/gal.lst
	$(MAKE) gfxdeps
	TARGET=gal SUBTARGET=galtext TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgal -Dtextgraphics -x$(OUTPUT_DIRECTORY)/gfxgaltext @target/gal/gfxgaltext.lst

# Sharp PC-G8xx/E2xx - Stefano Bodrato
g800_clib.lib:
	@echo ''
	@echo '--- Building Sharp PC-G8xx/E2xx Library ---'
	@echo ''
	$(call buildgeneric,g800)
	$(MAKE) -C games TARGET=g800
	$(MAKE) gfxdeps
	TARGET=g800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g800_clib @$(LISTFILE_DIRECTORY)/g800.lst
	$(MAKE) gfxdeps
	TARGET=g800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g850_clib @$(LISTFILE_DIRECTORY)/g850.lst
	TARGET=g800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g850b @$(LISTFILE_DIRECTORY)/g850b.lst

# Camputers Lynx - Stefano Bodrato
lynx_clib.lib:
	@echo ''
	@echo '--- Building Camputers Lynx Library ---'
	@echo ''
	$(MAKE) gfxdeps
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,lynx)
	$(MAKE) -C games TARGET=lynx
	TARGET=lynx TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORlynx -x$(OUTPUT_DIRECTORY)/lynx_clib @$(LISTFILE_DIRECTORY)/lynx.lst

# Sega Master system - contributed by Haroldo O. Pinheiro
sms_clib.lib:
	@echo ''
	@echo '--- Building Sega Master System Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=sms
	$(call buildgeneric,sms)
	$(MAKE) -C video/tms9918 TARGET=sms
	TARGET=sms TYPE=z80 $(LIBLINKER) -DFORsms -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sms_clib @$(LISTFILE_DIRECTORY)/sms.lst
	TARGET=gg TYPE=z80 $(LIBLINKER) -DFORgamegear -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gamegear @$(LISTFILE_DIRECTORY)/gamegear.lst

# Sega SC-3000 - stefano
sc3000_clib.lib:
	@echo ''
	@echo '--- Building SC-3000 System Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=sc3000
	$(call buildgeneric,sc3000)
	$(MAKE) -C video/tms9918 TARGET=sc3000
	TARGET=sc3000 TYPE=z80 $(LIBLINKER) -DFORsc3000 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sc3000_clib @$(LISTFILE_DIRECTORY)/sc3000.lst

# Gameboy - dom
gb_clib.lib:
	@echo ''
	@echo '--- Building Gameboy Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,gb)
	$(MAKE) -C games TARGET=gb
	$(MAKE) -C target/gb
	TARGET=gb TYPE=gbz80 $(LIBLINKER) -mgbz80 -DFORgb -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gb_clib @$(LISTFILE_DIRECTORY)/gb.lst


# Test platform - dom
test_clib.lib:
	@echo ''
	@echo '--- Building Test System Library ---'
	@echo ''
	$(call buildgeneric,test)
	TARGET=test TYPE=z80 $(LIBLINKER) -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test_clib @$(LISTFILE_DIRECTORY)/test.lst

testrcm_clib.lib:
	@echo ''
	@echo '--- Building Test System Library (Rabbit) ---'
	@echo ''
	$(call buildgeneric,test)
	TARGET=test TYPE=r2k $(LIBLINKER) -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testrcm_clib @$(LISTFILE_DIRECTORY)/testrcm.lst

test8080_clib.lib:
	@echo ''
	@echo '--- Building Test System Library (8080) ---'
	@echo ''
	$(call buildgeneric,test)
	TARGET=test TYPE=8080 $(LIBLINKER) -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test8080_clib @$(LISTFILE_DIRECTORY)/test8080.lst

testgbz80_clib.lib:
	@echo ''
	@echo '--- Building Test System Library (gbz80) ---'
	@echo ''
	$(call buildgeneric,test)
	TARGET=test TYPE=gbz80 $(LIBLINKER) -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testgbz80_clib @$(LISTFILE_DIRECTORY)/testgbz80.lst


# TRS 80 - stefano
trs80_clib.lib:
	@echo ''
	@echo '--- Building TRS 80 Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,trs80)
	$(MAKE) -C games TARGET=trs80
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORtrs80 -x$(OUTPUT_DIRECTORY)/trs80_clib @$(LISTFILE_DIRECTORY)/trs80.lst
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/trs80cpm @$(LISTFILE_DIRECTORY)/trs80cpm.lst
	@echo ''
	@echo '--- Building TRS 80 GFX libraires ---'
	@echo ''
	$(MAKE) gfxdeps
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/gfxtrs80 @$(LISTFILE_DIRECTORY)/gfxtrs80.lst
	$(MAKE) gfxdeps
	TARGET=eg2000 TYPE=z80 $(LIBLINKER) -DFOReg2000 -x$(OUTPUT_DIRECTORY)/gfxeg2000 @$(LISTFILE_DIRECTORY)/gfxeg2000.lst

trsdos.lib:
	$(MAKE) -C fcntl/trs80

# Canon X-07 lib - Stefano
x07_clib.lib:
	@echo ''
	@echo '--- Building Canon X-07 Library ---'
	@echo ''
	$(call buildgeneric,x07)
	TARGET=x07 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/x07_clib @$(LISTFILE_DIRECTORY)/x07.lst

# Sharp X1 (ANSI VT) - Karl Von Dyson (X1s.org)
x1_clib.lib:
	@echo ''
	@echo '--- Building Sharp X1 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,x1)
	$(MAKE) -C target/x1 
	TARGET=x1 TYPE=z80 $(LIBLINKER) -DFORx1 -x$(OUTPUT_DIRECTORY)/x1_clib @$(LISTFILE_DIRECTORY)/x1.lst

# Philips VG5000 lib - Joaopa, Stefano
vg5k_clib.lib:
	@echo ''
	@echo '--- Building Philips VG5000 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	$(call buildgeneric,vg5k)
	$(MAKE) -C games TARGET=vg5k
	TARGET=vg5k TYPE=ixiy $(LIBLINKER) --IXIY -DFORvg5k -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/vg5k_clib @$(LISTFILE_DIRECTORY)/vg5k.lst

# S-OS (The Sentinel) - Stefano
sos_clib.lib:
	@echo ''
	@echo '--- Building S-OS (The Sentinel) Library ---'
	@echo ''
	$(call buildgeneric,sos)
	$(MAKE) -C sos 
	TARGET=sos TYPE=z80 $(LIBLINKER) -DFORsos -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sos_clib.lib @$(LISTFILE_DIRECTORY)/sos.lst

# OSCA / FLOS - Stefano
osca_clib.lib:
	@echo ''
	@echo '--- Building Old School Computer Architecture Library ---'
	@echo ''
	$(call buildgeneric,osca)
	$(MAKE) -C games TARGET=osca
	$(MAKE) -C sdcard clean
	$(MAKE) -C fcntl/osca
	TARGET=osca TYPE=z80 $(LIBLINKER) -DFORosca -DSTANDARDESCAPECHARS -DSDHC_SUPPORT -x$(OUTPUT_DIRECTORY)/osca_clib.lib @$(LISTFILE_DIRECTORY)/osca.lst

# s1mp3
s1mp3_clib.lib:
	@echo ''
	@echo '--- Building s1mp3 Library ---'
	@echo ''
	$(call buildgeneric,s1mp3)
	$(MAKE) -C target/s1mp3
	TARGET=s1mp3 TYPE=z80 $(LIBLINKER) -DFORs1mp3 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/s1mp3_clib.lib @$(LISTFILE_DIRECTORY)/s1mp3.lst

# Preempt multitasking library - dom

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


clean: classic-clean new-clean

classic-clean:
	$(MAKE) -C ace clean
	$(MAKE) -C assert clean
	$(MAKE) -C cpm clean
	$(MAKE) -C ctype clean
	$(MAKE) -C fcntl clean
	$(MAKE) -C math clean
	$(MAKE) -C graphics clean
	$(MAKE) -C interrupts clean
	$(MAKE) -C rs232 clean
	$(MAKE) -C setjmp clean
	$(MAKE) -C stdio clean
	$(MAKE) -C stdlib clean
	$(MAKE) -C strings clean
	$(MAKE) -C regex clean
	$(MAKE) -C time clean
	$(MAKE) -C z80_crt0s clean
	$(MAKE) -C zxvgs clean
	$(MAKE) -C adt clean
	$(MAKE) -C adt-newlib clean
	$(MAKE) -C alloc clean
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
	$(MAKE) -C psg clean
	$(RM) cpc/*.o
	$(MAKE) -C sos clean
	$(MAKE) -C threading/preempt clean
	$(MAKE) -C sprites/software/sp1 clean
	$(MAKE) -C sdcard clean
	$(MAKE) -C games clean
	$(MAKE) -C math clean
	$(MAKE) -C compress/zx7 clean
	$(MAKE) -C font clean
	$(MAKE) -C arch clean
	$(MAKE) -C target clean
	$(MAKE) -C video/tms9918 clean
	$(RM) *.lib

new-clean:
	$(MAKE) -C _DEVELOPMENT clean

new-install-clean:
	$(MAKE) -C _DEVELOPMENT install-clean

install-clean: classic-clean new-install-clean

install:
	cp $(OUTPUT_DIRECTORY)/*.lib ../lib/clibs

