#
# Ah, that'd be nice, a library makefile!
#
# Problems? Contact the person to blame(!) above the section
# for the library
#
# $Id: Makefile,v 1.83 2007-05-17 16:25:53 stefano Exp $


include Make.config

all:	genlibs z88libs tilibs zxlibs \
	debug.lib \
	nc_clib.lib vz_clib.lib vzansi_clib.lib abc80_clib.lib \
	aceansi_clib.lib aquarius_clib.lib aquansi_clib.lib \
	cpc_clib.lib cpcansi_clib.lib cpcfs.lib cpc_math.lib cpcgray.lib \
	cpm_clib.lib c128ansi_clib.lib \
	m5_clib.lib msx_clib.lib mz_clib.lib mzansi_clib.lib \
	nascom_clib.lib nasansi_clib.lib ozansi_clib.lib\
	rex_clib.lib svi_clib.lib sam_clib.lib samansi_clib.lib \
	pps_clib.lib ppsansi_clib.lib embedded_clib.lib \
	zx81_clib.lib zx81ansi_clib.lib

genlibs: gen_math.lib malloc.lib z80_crt0.lib ndos.lib adt.lib balloc.lib \
         im2.lib rect.lib algorithm.lib

z88libs: z88_math.lib z88.lib z88_clib.lib net.lib z88net_clib.lib farz88.lib \
	 z88ansi_clib.lib gfx.lib 

tilibs: ti82ansi_clib.lib ti82_clib.lib ti83ansi_clib.lib ti83_clib.lib \
	ti83pansi_clib.lib ti83p_clib.lib ti85ansi_clib.lib ti85_clib.lib \
	ti86ansi_clib.lib ti86_clib.lib \
	tigray82.lib tigray83.lib tigray83p.lib tigray85.lib tigray86.lib

zxlibs: ts2068_clib.lib zx_clib.lib zxan_clib.lib ts2068an_clib.lib zxvgs.lib zx_math.lib zx_mathtiny.lib


# moving external shell scripts to makefile to make life easy on
# the windows platform devs (ie Me :-) -- gamesdeps.sh, gfxdeps.sh, tideps.sh

#  $Id: Makefile,v 1.83 2007-05-17 16:25:53 stefano Exp $
#  short script to sort out games dependencies
gamesdeps:
	$(RM) -f games/*.o

# $Id: Makefile,v 1.83 2007-05-17 16:25:53 stefano Exp $
#  short script to sort out gfx dependencies
gfxdeps:
	$(RM) -f graphics/*.o
	$(RM) -f graphics/ticalc/*.o
	$(RM) -f graphics/ace/*.o
	$(RM) -f graphics/gray/*.o
	$(RM) -f graphics/spectrum/*.o
	$(RM) -f graphics/vz200/*.o
	$(RM) -f graphics/zx81/*.o
	$(RM) -f graphics/z88/*.o
	$(RM) -f graphics/text/*.o
	$(RM) -f graphics/text6/*.o
	$(RM) -f graphics/sam/*.o

#  $Id: Makefile,v 1.83 2007-05-17 16:25:53 stefano Exp $
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

# interesting algorithms - aralbrec
algorithm.lib:
	@echo ''
	@echo '--- Building Algorithm Library  ---'
	@echo ''
	cd algorithm ; $(MAKE) ; cd ..

# rectangles, intervals and points - aralbrec
rect.lib:
	@echo ''
	@echo '--- Building Rectangles Library  ---'
	@echo ''
	cd rect ; $(MAKE) ; cd ..

# abstract data types library - aralbrec
adt.lib:
	@echo ''
	@echo '--- Building Abstract Data Types Library  ---'
	@echo ''
	cd adt ; $(MAKE) ; cd ..

# block memory allocator - aralbrec
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

# Garry's z88 far library - garry (probably dom now)
farz88.lib:
	@echo ''
	@echo '--- Building Z88 Far Malloc Library  ---'
	@echo ''
	cd farz88 ; $(MAKE) ; cd ..

# Generic maths build - dom
gen_math.lib:
	@echo ''
	@echo '--- Building Z80 Generic Maths Library  ---'
	@echo ''
	cd genmath; $(MAKE) ; cd ..

# Z88 maths build - dom
z88_math.lib:
	@echo ''
	@echo '--- Building Z88 Maths Library  ---'
	@echo ''
	cd z88math; $(MAKE) ; cd ..

# Graphics library (for both app and basic - diff libs though!) - dom
gfx.lib:
	@echo ''
	@echo '--- Building Z88 BASIC gfx Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	$(LIBLINKER) -xgfx -DFORz88 @z88gfx.lst
	$(MAKE) gfxdeps
	$(LIBLINKER) -xgfxapp -DAPPZ88 -DFORz88 @z88gfx.lst

# simple malloc library - dom
# adding multiple heaps and realloc - aralbrec
malloc.lib:
	@echo ''
	@echo '--- Building Near Malloc Library  ---'
	@echo ''
	cd malloc ; $(MAKE) ; cd ..

ndos.lib:
	cd fcntl/dummy ; $(MAKE) ; cd ../..

# Startup code (such as division etc) common to all z80s - dom
z80_crt0.lib:
	@echo ''
	@echo '--- Building Z80 crt0 Library  ---'
	@echo ''
	cd z80_crt0s ; $(MAKE) ; cd ..

# Z88DK DEBUG utilities
debug.lib:
	@echo ''
	@echo '--- Building DEBUG Library  ---'
	@echo ''
	cd debug ; $(MAKE) ; cd ..

# Custom z88 routines for application - dom
z88.lib:
	@echo ''
	@echo '--- Building Z88 Custom Library  ---'
	@echo ''
	cd z88 ; $(MAKE) ; cd ..

# ZSock API (wrappers to package calls) - dom
net.lib:
	@echo ''
	@echo '--- Building Z88 ZSock Library  ---'
	@echo ''
	cd net ; $(MAKE) ; cd ..

# z88 library - dom
z88_clib.lib:
	@echo ''
	@echo '--- Building Z88 Library  ---'
	@echo ''
	cd fcntl ; $(MAKE) lz88 ; cd ..
	cd stdio ; $(MAKE) lz88 ; cd ..
	cd stdlib ; $(MAKE) lz88 ; cd ..
	cd strings ; $(MAKE) ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lz88 ; cd ..
	cd rs232 ; $(MAKE) lz88 ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) lz88; cd ..
	$(LIBLINKER) -DFORz88 -xz88_clib @z88.lst

# z88 ansi library - dom
z88ansi_clib.lib:
	@echo ''
	@echo '--- Building Z88 ANSI Library  ---'
	@echo ''
	cd fcntl ; $(MAKE) lz88 ; cd ..
	cd stdio ; $(MAKE) lz88 ; cd ..
	cd stdlib ; $(MAKE) lz88 ; cd ..
	cd strings ; $(MAKE) ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lz88 ; cd ..
	cd rs232 ; $(MAKE) lz88 ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -xz88ansi_clib @z88ansi.lst

# Network stdio - dom
z88net_clib.lib:
	@echo ''
	@echo '--- Building Z88 Network Aware Library  ---'
	@echo ''
	cd fcntl ; $(MAKE) lz88 ; cd ..
	cd stdio ; $(MAKE) lz88net ; cd ..
	cd stdlib ; $(MAKE) lz88 ; cd ..
	cd strings ; $(MAKE) ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lz88 ; cd ..
	cd rs232 ; $(MAKE) lz88 ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -xz88net_clib @z88net.lst

# 64/32 column library for ZX Spectrum - dom/stefano
zx_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd fcntl ; $(MAKE) lzx ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lzx ; cd ..
	cd rs232 ; $(MAKE) lzx ; cd ..
	$(MAKE) gamesdeps
	cd spectrum ; $(MAKE) ; cd ..
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORzx -xzx_clib @zx.lst

# 64/32 column library for TS2068 - dom/stefano/alvin
ts2068_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd fcntl ; $(MAKE) lzx ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lzx ; cd ..
	cd rs232 ; $(MAKE) lzx ; cd ..
	$(MAKE) gamesdeps
	cd spectrum ; $(MAKE) ; cd ..
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORzx -xts2068_clib @ts2068.lst

# ZXVGS - yarek
zxvgs.lib:
	@echo ''
	@echo '--- Building ZXVGS Library  ---'
	@echo ''
	cd fcntl ; $(MAKE) lzxvgs ; cd ..
	cd zxvgs; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORzx -xzxvgs @zxvgs.lst

# ZX Spectrum maths library - Stefano
zx_math.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Maths Library ---'
	@echo ''
	cd zxmath ; $(MAKE) zx_math ; cd ..

zx_mathtiny.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Tiny Maths Library ---'
	@echo ''
	cd zxmath ; $(MAKE) zx_mathtiny ; cd ..

# vt100 for sprinter - dom
ppsansi_clib.lib:
	@echo ''
	@echo '--- Building Sprinter Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd fcntl ; $(MAKE) lpps ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lpps ; cd ..
	cd rs232 ; $(MAKE) lzx ; cd ..
	$(MAKE) gamesdeps
	cd spectrum ; $(MAKE) ; cd ..
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORzx -xppsansi_clib @ppsansi.lst

# Native for sprinter - dom
pps_clib.lib:
	@echo ''
	@echo '--- Building Sprinter Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd fcntl ; $(MAKE) lpps ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lpps ; cd ..
	cd rs232 ; $(MAKE) lzx ; cd ..
	$(MAKE) gamesdeps
	cd spectrum ; $(MAKE) ; cd ..
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORzx -xpps_clib @pps.lst

# vt100 C lib for spectrum - stefano/dom
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
zxan_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum ANSI Library  ---'
	@echo ''
	$(RM) stdio/ansi/spectrum/f_ansi_char.o
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd fcntl ; $(MAKE) lzx ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lzx ; cd ..
	cd rs232 ; $(MAKE) lzx ; cd ..
	$(MAKE) gamesdeps
	cd spectrum ; $(MAKE) ; cd ..
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORzx $(COLDEFS) -xzxan_clib @zxansi.lst

# vt100 C lib for TS2068 - stefano/dom
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
ts2068an_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum ANSI Library  ---'
	@echo ''
	$(RM) stdio/ansi/spectrum/f_ansi_char.o
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) lzx ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd fcntl ; $(MAKE) lzx ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lzx ; cd ..
	cd rs232 ; $(MAKE) lzx ; cd ..
	$(MAKE) gamesdeps
	cd spectrum ; $(MAKE) ; cd ..
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORzx $(COLDEFS) -xts2068an_clib @ts2068an.lst

# Untested C lib for NC100 machines - dom
nc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad NC100 Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -xnc_clib @nc100.lst

# VZ200/300 lib - Stefano
vz_clib.lib:
	@echo ''
	@echo '--- Building VZ200/300 Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORvz -xvz_clib @vz200.lst

# VZ200 ansi lib - Stefano
vzansi_clib.lib:
	@echo ''
	@echo '--- Building VZ200/300 ANSI Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORvz -xvzansi_clib @vzansi.lst

# ZX81 lib - Stefano
zx81_clib.lib:
	@echo ''
	@echo '--- Building ZX81 Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -IXIY -DFORzx81 -xzx81_clib @zx81.lst

# ZX81 ansi lib - Stefano
zx81ansi_clib.lib:
	@echo ''
	@echo '--- Building ZX81 ANSI Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -IXIY -DFORzx81 -xzx81ansi_clib @zx81ansi.lst

# Texas Instrument's calculators: - stefano/henk
# almost the same lib code with different -D flag set
# that's why we force most of the lib code to be rebuilt (tideps.sh)
ti82ansi_clib.lib:
	@echo ''
	@echo '--- Building TI82 ANSI Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti82 -DPACKEDFONT -xti82ansi_clib @ticansi.lst

ti82_clib.lib:
	@echo ''
	@echo '--- Building TI82 Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti82 -xti82_clib @ticalc.lst

tigray82.lib:
	@echo ''
	@echo '--- Building TI82 Grey Library  ---'
	@echo ''
	$(MAKE) tideps
	$(LIBLINKER) -DFORti82 -xtigray82 @tigray.lst


ti83ansi_clib.lib:
	@echo ''
	@echo '--- Building TI83 ANSI Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti83 -DPACKEDFONT -xti83ansi_clib @ticansi.lst

ti83_clib.lib:
	@echo ''
	@echo '--- Building TI83 Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti83 -xti83_clib @ticalc.lst

tigray83.lib:
	@echo ''
	@echo '--- Building TI83 Grey Library  ---'
	@echo ''
	$(MAKE) tideps
	$(LIBLINKER) -DFORti83 -xtigray83 @tigray.lst

ti83pansi_clib.lib:
	@echo ''
	@echo '--- Building TI83+ ANSI Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti83p -DPACKEDFONT -xti83pansi_clib @ticansi.lst

ti83p_clib.lib:
	@echo ''
	@echo '--- Building TI83+ Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti83p -xti83p_clib @ticalc.lst

tigray83p.lib:
	@echo ''
	@echo '--- Building TI83+ Grey Library  ---'
	@echo ''
	$(MAKE) tideps
	$(LIBLINKER) -DFORti83p -xtigray83p @tigray.lst

ti85ansi_clib.lib:
	@echo ''
	@echo '--- Building TI85 ANSI Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti85 -DPACKEDFONT -xti85ansi_clib @ticansi.lst

ti85_clib.lib:
	@echo ''
	@echo '--- Building TI85 Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti85 -xti85_clib @ticalc.lst

tigray85.lib:
	@echo ''
	@echo '--- Building TI85 Grey Library  ---'
	@echo ''
	$(MAKE) tideps
	$(LIBLINKER) -DFORti85 -xtigray85 @tigray.lst

ti86ansi_clib.lib:
	@echo ''
	@echo '--- Building TI86 ANSI Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti86 -DPACKEDFONT -xti86ansi_clib @ticansi.lst

ti86_clib.lib:
	@echo ''
	@echo '--- Building TI86 Library  ---'
	@echo ''
	$(MAKE) tideps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORti86 -xti86_clib @ticalc.lst

tigray86.lib:
	@echo ''
	@echo '--- Building TI86 Grey Library  ---'
	@echo ''
	$(MAKE) tideps
	$(LIBLINKER) -DFORti86 -xtigray86 @tigray.lst

# vt100 C lib for the Sharp OZ family - stefano
# use -DPACKEDFONT for tiny 50->80 column modes
ozansi_clib.lib:
	@echo ''
	@echo '--- Building Sharp OZ family ANSI Library  ---'
	@echo ''
	$(RM) -f stdio/ansi/oz/f_ansi_char.o
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	cd oz ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORoz -DPACKEDFONT -xozansi_clib @ozansi.lst

# CPM lib - Stefano/dom
cpm_clib.lib:
	@echo ''
	@echo '--- Building CP/M Library ---'
	@echo ''
	cd fcntl ; $(MAKE) lcpm ; cd ..
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) lcpm ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -xcpm_clib @cpm.lst

# Sharp MZ lib - Stefano
mz_clib.lib:
	@echo ''
	@echo '--- Building Sharp MZ Library ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -xmz_clib @mz.lst

# Sharp MZ ansi lib - Stefano
mzansi_clib.lib: 
	@echo ''
	@echo '--- Building Sharp MZ ANSI Library ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -xmzansi_clib @mzansi.lst

# ABC80 ANSI library - Stefano
abc80_clib.lib:
	@echo ''
	@echo '--- Building ABC80 Library ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -xabc80_clib @abc80.lst

# Jupiter ACE library - Stefano
aceansi_clib.lib:
	@echo ''
	@echo '--- Building Jupiter Ace ANSI Library ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORjupiter -xaceansi_clib.lib @aceansi.lst

# Mattel Aquarius library - Stefano
aquarius_clib.lib:
	@echo ''
	@echo '--- Building Mattel Aquarius Library ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORaquarius -xaquarius_clib.lib @aquarius.lst

# Mattel Aquarius ANSI library - Stefano
aquansi_clib.lib:
	@echo ''
	@echo '--- Building Mattel Aquarius ANSI Library ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORaquarius -xaquansi_clib.lib @aquansi.lst

# Xircom REX 6000 library - Dominic
rex_clib.lib:
	@echo ''
	@echo '--- Building Xircom Rex Library  ---'
	@echo ''
	cd strings; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd rex    ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORrex -xrex_clib.lib @rex6000.lst

# Sam Coupe library - Stefano & Frode
sam_clib.lib:
	@echo ''
	@echo '--- Building Sam Coupe Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORsam -xsam_clib @sam.lst

# Sam Coupe library - Stefano & Frode
samansi_clib.lib:
	@echo ''
	@echo '--- Building Sam Coupe ANSI Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gamesdeps
	cd games ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORsam -xsamansi_clib @samansi.lst

# Spectravideo SVI library - Stefano
svi_clib.lib:
	@echo ''
	@echo '--- Building Spectravideo Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORsvi -xsvi_clib @svi.lst

# MSX1 library - Stefano
msx_clib.lib:
	@echo ''
	@echo '--- Building MSX Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORmsx -xmsx_clib @msx.lst

# NASCOM library - Stefano
nascom_clib.lib:
	@echo ''
	@echo '--- Building NASCOM Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORnascom -xnascom_clib @nascom.lst

nasansi_clib.lib:
	@echo ''
	@echo '--- Building NASCOM ANSI Library  ---'
	@echo ''
	$(MAKE) gfxdeps
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORnascom -xnasansi_clib @nasansi.lst

# SORD M5 library - Stefano
m5_clib.lib:
	@echo ''
	@echo '--- Building SORD M5 Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORm5 -xm5_clib @m5.lst

# Amstrad CPC library - Stefano
cpc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad CPC Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORcpc -xcpc_clib @cpc.lst

cpcansi_clib.lib:
	@echo ''
	@echo '--- Building Amstrad CPC ANSI Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORcpc -xcpcansi_clib @cpcansi.lst

cpcgray.lib:
	@echo ''
	@echo '--- Building CPC Pseudo Grey Library  ---'
	@echo ''
	$(LIBLINKER) -DFORcpc -xcpcgray @cpcgray.lst

cpcfs.lib:
	@echo ''
	@echo '--- Building Amstrad CPC fcntl Library ---'
	@echo ''
	cd fcntl ; $(MAKE) lcpc ; cd ..
	$(LIBLINKER) -DFORcpc -xcpcfs @cpcfs.lst


# Amstrad CPC maths libraries - Dom
cpc_math.lib:
	@echo ''
	@echo '--- Building Amstrad CPC Maths Libraries  ---'
	@echo ''
	cd cpcmath ; $(MAKE) ; cd ..
	

# Commodore 128 (Z80 mode) library - Stefano
c128ansi_clib.lib:
	@echo ''
	@echo '--- Building Commodore 128 ANSI Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORc128 -xc128ansi_clib @c128ansi.lst

# Grundy NewBrain library - Stefano
newbrain_clib.lib:
	@echo ''
	@echo '--- Building Grundy NewBrain Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) generic ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd time ; $(MAKE) lnewbrain ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(MAKE) gfxdeps
	$(LIBLINKER) -DFORnewbrain -xnewbrain_clib @newbrain.lst

# embedded target - contributed by Daniel Wallner
embedded_clib.lib:
	@echo ''
	@echo '--- Building Embedded (ns16450) Library  ---'
	@echo ''
	cd strings ; $(MAKE) ; cd ..
	cd stdlib ; $(MAKE) gen ; cd ..
	cd stdio ; $(MAKE) gen ; cd ..
	cd printflike ; $(MAKE) ; cd ..
	cd setjmp ; $(MAKE) ; cd ..
	cd assert ; $(MAKE) ; cd ..
	$(LIBLINKER) -DFORembedded -xembedded_clib @embedded.lst

clean:
	cd assert ; $(MAKE) clean ; cd ..
	cd ctype ; $(MAKE) clean ; cd ..
	cd farz88 ; $(MAKE) clean ; cd ..
	cd fcntl ; $(MAKE) clean ; cd ..
	cd genmath ; $(MAKE) clean ; cd ..
	cd graphics ; $(MAKE) clean ; cd ..
	cd malloc ; $(MAKE) clean ; cd ..
	cd net    ; $(MAKE) clean ; cd ..
	cd printflike ; $(MAKE) clean ; cd ..
	cd rex ; $(MAKE) clean ; cd ..
	cd rs232 ; $(MAKE) clean ; cd ..
	cd setjmp ; $(MAKE) clean ; cd ..
	cd spectrum ; $(MAKE) clean ; cd ..
	cd stdio ; $(MAKE) clean ; cd ..
	cd stdlib ; $(MAKE) clean ; cd ..
	cd strings ; $(MAKE) clean ; cd ..
	cd time ; $(MAKE) clean ; cd ..
	cd z80_crt0s; $(MAKE) clean ; cd ..
	cd z88 ; $(MAKE) clean ; cd ..
	cd z88math ; $(MAKE) clean ; cd ..
	cd zxvgs ; $(MAKE) clean ; cd ..
	$(RM) *.lib
	cd games ; $(MAKE) clean ; cd ..
	cd cpcmath ; $(MAKE) clean ; cd ..
	cd zxmath ; $(MAKE) clean ; cd ..
	cd adt ; $(MAKE) clean ; cd ..
	cd balloc ; $(MAKE) clean ; cd ..
	cd im2 ; $(MAKE) clean ; cd ..
	cd rect ; $(MAKE) clean ; cd ..
	cd algorithm ; $(MAKE) clean ; cd ..

install:
	cp *.lib ../lib/clibs
