# Ah, that'd be nice, a library makefile!
#
# Problems? Contact the person to blame(!) above the section
# for the library
#
# $Id: Makefile,v 1.265+ ...now on GIT $


include Make.config

TARGETS ?= all

TOCREATE =

# $1 = target
# $2 = libs
check_target = $(if $(or $(filter $(1),$(TARGETS)), $(filter all,$(TARGETS))),$(2),)

CPMLIBS = cpm_clib.lib cpm8080_clib.lib cpmdevice.lib cpmdevice_8080.lib gfxvio.lib
GENLIBS = z80iy_crt0.lib z80n_crt0.lib 8080_crt0.lib gbz80_crt0.lib r2k_crt0.lib z80_crt0.lib math48.lib genmath.lib mbf32.lib mbf64.lib math16.lib math32.lib daimath32.lib am9511.lib gendos.lib ndos.lib  lib3d.lib fastmath.lib preempt.lib sp1-all 
GENLIBS += 8085_opt.lib ez80_opt.lib z180_opt.lib


TOCREATE := $(call check_target,altair8800,altair8800_clib.lib gfxvti.lib gfxvdm.lib)
TOCREATE += $(call check_target,ace,ace_clib.lib gfxace.lib gfxaceudg.lib)
TOCREATE += $(call check_target,abc80,abc80_clib.lib)
TOCREATE += $(call check_target,abc800,abc800_clib.lib)
TOCREATE += $(call check_target,adam,adam.lib $(CPMLIBS))
TOCREATE += $(call check_target,alphatro,alphatro_clib.lib)
TOCREATE += $(call check_target,aquarius,aquarius_clib.lib gfxaq48.lib)
TOCREATE += $(call check_target,attache,attache.lib $(CPMLIBS))
TOCREATE += $(call check_target,aussie,aussie.lib $(CPMLIBS))
TOCREATE += $(call check_target,bee,bee_clib.lib microbee.lib $(CPMLIBS))
TOCREATE += $(call check_target,bic,bic.lib $(CPMLIBS))
TOCREATE += $(call check_target,bit90,bit90.lib coleco_clib.lib)
TOCREATE += $(call check_target,bondwell,bondwell.lib $(CPMLIBS))
TOCREATE += $(call check_target,bondwell2,bondwell2.lib $(CPMLIBS))
TOCREATE += $(call check_target,c128,c128ansi_clib.lib gfx128.lib gfx128udg.lib gfx128hr.lib gfx128hr480.lib)
TOCREATE += $(call check_target,c7420,c7420_clib.lib)
TOCREATE += $(call check_target,coleco,coleco_clib.lib)
TOCREATE += $(call check_target,cpc,cpc_clib.lib cpcfs.lib cpc_math.lib)
TOCREATE += $(call check_target,cpm,$(CPMLIBS))
TOCREATE += $(call check_target,dai,dai_clib.lib)
TOCREATE += $(call check_target,einstein,einstein.lib $(CPMLIBS))
TOCREATE += $(call check_target,embedded,embedded_clib.lib)
TOCREATE += $(call check_target,enterprise,enterprise_clib.lib gfxep.lib gfxephr.lib)
TOCREATE += $(call check_target,excali64,excali64_clib.lib $(CPMLIBS))
TOCREATE += $(call check_target,fp1100,fp1100_clib.lib)
TOCREATE += $(call check_target,g800,g800_clib.lib)
TOCREATE += $(call check_target,gal,gal_clib.lib)
TOCREATE += $(call check_target,gb,gb_clib.lib)
TOCREATE += $(call check_target,gl,gl_clib.lib)
TOCREATE += $(call check_target,gl6000,gl6000_clib.lib)
TOCREATE += $(call check_target,hemc,hemc_clib.lib)
TOCREATE += $(call check_target,hgmc,hgmc_clib.lib)
TOCREATE += $(call check_target,homelab,homelab_clib.lib)
TOCREATE += $(call check_target,homelab2,homelab2_clib.lib)
TOCREATE += $(call check_target,kaypro,gfxkp.lib $(CPMLIBS))
TOCREATE += $(call check_target,kc,kc_clib.lib)
TOCREATE += $(call check_target,kramermc,kramermc_clib.lib)
TOCREATE += $(call check_target,krokha,krokha_clib.lib)
TOCREATE += $(call check_target,lambda, mlambda.lib mlambda_tiny.lib lambda_clib.lib gfxlambda.lib )
TOCREATE += $(call check_target,laser500,laser500_clib.lib)
TOCREATE += $(call check_target,lm80c,lm80c_clib.lib)
TOCREATE += $(call check_target,lviv,lviv_clib.lib)
TOCREATE += $(call check_target,lynx,lynx_clib.lib)
TOCREATE += $(call check_target,m100,m100_clib.lib)
TOCREATE += $(call check_target,m5,m5_clib.lib)
TOCREATE += $(call check_target,mc1000,mc1000_clib.lib)
TOCREATE += $(call check_target,mikro80,mikro80_clib.lib)
TOCREATE += $(call check_target,msx,msx_clib.lib)
TOCREATE += $(call check_target,mtx,mtx_clib.lib)
TOCREATE += $(call check_target,multi8,multi8_clib.lib)
TOCREATE += $(call check_target,myvision,myvision_clib.lib)
TOCREATE += $(call check_target,mz,mz_clib.lib)
TOCREATE += $(call check_target,mz2500,mz2500_clib.lib)
TOCREATE += $(call check_target,nascom,nascom_clib.lib)
TOCREATE += $(call check_target,nc,nc_clib.lib gfxnc100.lib gfxzcn.lib gfxnc200.lib zxfcntl)
TOCREATE += $(call check_target,newbrain,newbrain_clib.lib)
TOCREATE += $(call check_target,osborne,gfxosborne1.lib $(CPMLIBS))
TOCREATE += $(call check_target,ondra,ondra_clib.lib)
TOCREATE += $(call check_target,osca,osca_clib.lib)
TOCREATE += $(call check_target,oz,ozansi_clib.lib)
TOCREATE += $(call check_target,p2000,p2000_clib.lib)
TOCREATE += $(call check_target,pacman,pacman_clib.lib)
TOCREATE += $(call check_target,pasopia7,pasopia7_clib.lib)
TOCREATE += $(call check_target,pc6001,pc6001_clib.lib)
TOCREATE += $(call check_target,pc88,pc88_clib.lib)
TOCREATE += $(call check_target,pencil2,pencil2_clib.lib)
TOCREATE += $(call check_target,pmd85,pmd85_clib.lib)
TOCREATE += $(call check_target,pps,pps_clib.lib)
TOCREATE += $(call check_target,primo,primo_clib.lib)
TOCREATE += $(call check_target,pv1000,pv1000_clib.lib)
TOCREATE += $(call check_target,pv2000,pv2000_clib.lib)
TOCREATE += $(call check_target,px4,px4.lib $(CPMLIBS))
TOCREATE += $(call check_target,px8,px8.lib $(CPMLIBS))
TOCREATE += $(call check_target,radio86,radio86_clib.lib)
TOCREATE += $(call check_target,rcmx000,rcmx000_clib.lib)
TOCREATE += $(call check_target,rc700,rc700.lib $(CPMLIBS))
TOCREATE += $(call check_target,rex,rex_clib.lib)
TOCREATE += $(call check_target,rx78,rx78_clib.lib)
TOCREATE += $(call check_target,s1mp3,s1mp3_clib.lib)
TOCREATE += $(call check_target,sam,sam_clib.lib)
TOCREATE += $(call check_target,sc3000,sc3000_clib.lib)
TOCREATE += $(call check_target,smc777,smc777_cpm.lib $(CPMLIBS))
TOCREATE += $(call check_target,sms,sms_clib.lib)
TOCREATE += $(call check_target,spc1000,spc1000_clib.lib)
TOCREATE += $(call check_target,srr,srr_clib.lib)
TOCREATE += $(call check_target,sos,sos_clib.lib)
TOCREATE += $(call check_target,special,special_clib.lib)
TOCREATE += $(call check_target,super80,super80_clib.lib super80_vduem_clib.lib)
TOCREATE += $(call check_target,sv8000,sv8000_clib.lib)
TOCREATE += $(call check_target,svi,svi_clib.lib)
TOCREATE += $(call check_target,test,test_clib.lib test8080_clib.lib testrcm_clib.lib testgbz80_clib.lib)
TOCREATE += $(call check_target,ti82,ti82_clib.lib)
TOCREATE += $(call check_target,ti83,ti83_clib.lib)
TOCREATE += $(call check_target,ti83p,ti83p_clib.lib)
TOCREATE += $(call check_target,ti85,ti85_clib.lib)
TOCREATE += $(call check_target,ti86,ti86_clib.lib)
TOCREATE += $(call check_target,tiki100,tiki100.lib $(CPMLIBS))
TOCREATE += $(call check_target,trs80, trs80_clib.lib trsdos.lib gfxtrs80.lib gfxeg2000.lib grafyx3.lib grafyx4.lib)
TOCREATE += $(call check_target,ts2068, ts2068_clib.lib m2068.lib)
TOCREATE += $(call check_target,tvc, tvc_clib.lib)
TOCREATE += $(call check_target,vector06c,vector06c_clib.lib)
TOCREATE += $(call check_target,vg5k,vg5k_clib.lib)
TOCREATE += $(call check_target,vz,vz_clib.lib)
TOCREATE += $(call check_target,x07,x07_clib.lib)
TOCREATE += $(call check_target,x1,x1_clib.lib x1_cpm.lib $(CPMLIBS))
TOCREATE += $(call check_target,z1013,z1013_clib.lib)
TOCREATE += $(call check_target,z80tvgame,z80tvgame_clib.lib)
TOCREATE += $(call check_target,z88,z88_clib.lib z88_math.lib)
TOCREATE += $(call check_target,z9001,z9001_clib.lib gfx9001krt.lib)
TOCREATE += $(call check_target,zx, zx_clib.lib mzx.lib mzx_tiny.lib zxrom.lib)
TOCREATE += $(call check_target,zxvgs, zxvgs.lib)
TOCREATE += $(call check_target,zx80, zx80_clib.lib)
TOCREATE += $(call check_target,zx81, zx81_clib.lib gfx81.lib gfx81udg.lib gfx81hr64.lib gfx81hr192.lib m81.lib m81_tiny.lib)
TOCREATE += $(call check_target,zxn, zxn_clib.lib zxfcntl)


TOCREATE += $(GENLIBS)

all: $(TOCREATE)


# Arg1: target
# Arg2: Graphics flavour
define buildgeneric
	$(MAKE) -C stdio
	$(MAKE) -C time
	$(MAKE) -C font
	$(MAKE) -C input
	$(MAKE) -C stdlib 
	$(MAKE) -C gfx TARGET=$(1) FLAVOUR=$(if $(2),$(2),narrow)
	$(MAKE) -C psg TARGET=$(1)
endef

define buildcrt
	$(MAKE) -C ctype
	$(MAKE) -C libgen
	$(MAKE) -C strings
	$(MAKE) -C interrupts
	$(MAKE) -C regex
	$(MAKE) -C setjmp
	$(MAKE) -C debug
	$(MAKE) -C assert
	$(MAKE) -C font
	$(MAKE) -C compress
	$(MAKE) -C alloc
	$(MAKE) -C debug
	$(MAKE) -C adt
	$(MAKE) -C adt-newlib
	$(MAKE) -C algorithm
	$(MAKE) -C rect
	$(MAKE) -C arch
	$(MAKE) -C stdlib
	$(MAKE) -C z80_crt0s
endef

#  short script to sort out ticalc dependencies
msxdeps:
	$(MAKE) -C target/msx clean

zx81deps:
	$(MAKE) -C target/zx81 clean


# Generic maths build - dom, stefano
genmath.lib:
	@echo ''
	@echo '--- Building Z80 Generic Maths Library ---'
	@echo ''
	$(MAKE) -C math/genmath

mbf32.lib:
	@echo ''
	@echo '--- Building Microsoft Single Precision Maths Library ---'
	@echo ''
	$(MAKE) -C math/mbf32

# math16 build - @feilipu
math16.lib:
	@echo ''
	@echo '--- Building IEEE Half Precision Maths Library ---'
	@echo ''
	$(MAKE) -C math/math16
	
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

daimath32.lib:
	@echo ''
	@echo '--- Building DAI 32-bit 8080 Maths Library ---'
	@echo ''
	$(MAKE) -C math/daimath32

am9511.lib:
	@echo ''
	@echo '--- Building Am9511 APU Maths Library ---'
	@echo ''
	$(MAKE) -C math/am9511

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

ndos.lib:
	$(MAKE) -C fcntl/dummy

gendos.lib:
	$(MAKE) -C fcntl/gen_rnd

# z88 library - dom
z88_clib.lib:
	@echo ''
	@echo '--- Building Z88 Library ---'
	@echo ''
	$(call buildgeneric,z88)
	$(MAKE) -C games TARGET=z88
	$(MAKE) -C target/z88
	TARGET=z88 TYPE=z80 $(LIBLINKER) -I$(Z88DK_LIB)/target/z88/def -DSTANDARDESCAPECHARS -DFORz88 -x$(OUTPUT_DIRECTORY)/z88_clib @$(LISTFILE_DIRECTORY)/z88.lst

# ZX Spectrum fcntl - dom/stefano
zxfcntl:
	$(MAKE) -C target/zx/fcntl

# 64/32 column library for ZX Spectrum - dom/stefano
# ansi flags
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
zx_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Library ---'
	@echo ''
	$(call buildgeneric,zx)
	$(MAKE) -C target/zx 
	$(MAKE) -C target/zx-common TARGET=zx
	$(MAKE) -C games TARGET=zx
	TARGET=zx TYPE=z80 $(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zx_clib @$(LISTFILE_DIRECTORY)/zx.lst
	TARGET=zx TYPE=z80 $(LIBLINKER) -DFORzx $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zxcpm @$(LISTFILE_DIRECTORY)/target/zx/zx_cpm.lst

zxn_clib.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Next Library ---'
	@echo ''
	$(call buildgeneric,zxn,wide)
	$(MAKE) -C target/zx TARGET=zxn
	$(MAKE) -C target/zx-common TARGET=zxn
	$(MAKE) -C games TARGET=zxn
	$(MAKE) -C target/zxn TARGET=zxn
	TARGET=zxn TYPE=z80n $(LIBLINKER) -mz80n -DFORzxn -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zxn_clib @$(LISTFILE_DIRECTORY)/zxn.lst

# 64/32 column library for TS2068 - dom/stefano/alvin
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
ts2068_clib.lib:
	@echo ''
	@echo '--- Building TS2068 (Spectrum clone) Library ---'
	@echo ''
	$(call buildgeneric,ts2068,wide)
	$(MAKE) -C games TARGET=ts2068
	$(MAKE) -C target/zx TARGET=ts2068
	$(MAKE) -C target/ts2068 TARGET=ts2068
	$(MAKE) -C target/zx-common TARGET=ts2068
	TARGET=ts2068 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORzx -DFORts2068 -DA80COL -x$(OUTPUT_DIRECTORY)/ts2068_clib @$(LISTFILE_DIRECTORY)/ts2068.lst

# ZXROM - stefano
zxrom.lib:
	@echo ''
	@echo '--- Building ZXROM Library ---'
	@echo ''
	$(RM) target/zx/stdio/generic_console_scrollup.o
	$(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS -DNOROMCALLS -x$(OUTPUT_DIRECTORY)/zxrom @$(LISTFILE_DIRECTORY)/zxrom.lst
	$(RM) target/zx/stdio/generic_console_scrollup.o

# ZXVGS - yarek
zxvgs.lib:
	@echo ''
	@echo '--- Building ZXVGS Library ---'
	@echo ''
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/zxvgs @$(LISTFILE_DIRECTORY)/target/zxvgs/zxvgs.lst

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
	$(call buildgeneric,pacman,"text6 narrow")
	TARGET=pacman TYPE=z80 $(LIBLINKER) -DFORpacman -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pacman_clib @$(LISTFILE_DIRECTORY)/pacman.lst

# Philips P2000 lib - Stefano
p2000_clib.lib:
	@echo ''
	@echo '--- Building Philips P2000 Library ---'
	@echo ''
	$(call buildgeneric,p2000,"text6 narrow")
	$(MAKE) -C games TARGET=p2000
	TARGET=p2000 TYPE=z80 $(LIBLINKER) -DFORp2000 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/p2000_clib @$(LISTFILE_DIRECTORY)/p2000.lst

# PC6001 lib - Stefano
pc6001_clib.lib:
	@echo ''
	@echo '--- Building PC6001 Library ---'
	@echo ''
	$(call buildgeneric,pc6001)
	$(MAKE) -C games TARGET=pc6001
	TARGET=pc6001 TYPE=z80 $(LIBLINKER) -DFORpc6001 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc6001_clib @$(LISTFILE_DIRECTORY)/pc6001.lst
	
# PC8801 lib - Stefano
pc88_clib.lib:
	@echo ''
	@echo '--- Building PC8801 Library ---'
	@echo ''
	$(MAKE) -C psg TARGET=pc88
	$(call buildgeneric,pc88,"wide narrow")
	$(MAKE) -C games TARGET=pc88
	TARGET=pc88 TYPE=z80 $(LIBLINKER) -DFORpc88 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc88_clib @$(LISTFILE_DIRECTORY)/pc88.lst
	@echo ''
	@echo '--- Building PC8801 160x100 graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=pc88 FLAVOUR="narrow"
	TARGET=pc88 TYPE=z80 $(LIBLINKER) -DFORpc88 -x$(OUTPUT_DIRECTORY)/gfxpc88 @$(LISTFILE_DIRECTORY)/target/pc88/gfxpc88.lst
	@echo ''
	@echo '--- Building PC8801 640x200 Mono Graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=pc88 SUBTYPE=pc88hr200 FLAVOUR="wide"
	TARGET=pc88 TYPE=z80 $(LIBLINKER) -DFORpc88hr200 -x$(OUTPUT_DIRECTORY)/gfxpc88hr200 @$(LISTFILE_DIRECTORY)/target/pc88/gfxpc88hr200.lst

# Native for sprinter - dom
pps_clib.lib:
	@echo ''
	@echo '--- Building Sprinter Library ---'
	@echo ''
	$(call buildgeneric,pps)
	$(MAKE) -C target/pps
	$(MAKE) -C target/zx TARGET=pps
	$(MAKE) -C games TARGET=pps
	TARGET=pps TYPE=z80 $(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pps_clib @$(LISTFILE_DIRECTORY)/pps.lst

# Epson PX4 lib - Stefano	
px4.lib:
	@echo ''
	@echo '--- Building PX-4/HC-40 Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=cpm SUBTYPE=px4 FLAVOUR="narrow"
	TARGET=px4 TYPE=z80 $(LIBLINKER) -DFORpx4 -x$(OUTPUT_DIRECTORY)/px4 @$(LISTFILE_DIRECTORY)/target/px4/px4.lst

# Epson PX8 lib - Stefano	
px8.lib:
	@echo ''
	@echo '--- Building PX-8/Geneva Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=cpm SUBTYPE=px8 FLAVOUR="wide"
	TARGET=px8 TYPE=z80 $(LIBLINKER) -DFORpx8 -x$(OUTPUT_DIRECTORY)/px8 @$(LISTFILE_DIRECTORY)/target/px8/px8.lst

# VZ200/300 lib - Stefano
vz_clib.lib:
	@echo ''
	@echo '--- Building VZ200/300 Library ---'
	@echo ''
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
	$(MAKE) -C target/zx80 
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
	TARGET=zx81 TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS -IXIY -DFORzx81 $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zx81_clib @$(LISTFILE_DIRECTORY)/zx81.lst
	$(MAKE) zx81deps

# Lambda 8300 lib - Stefano
lambda_clib.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(call buildgeneric,zx81)
	$(MAKE) -C games TARGET=zx81
	TARGET=zx81 SUBTARGET=lambda TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS -IXIY -DFORlambda -x$(OUTPUT_DIRECTORY)/lambda_clib @$(LISTFILE_DIRECTORY)/zx81.lst
	$(MAKE) zx81deps

# ZX81 std graphics lib - Stefano
gfx81.lib:
	@echo ''
	@echo '--- Building ZX81 Standard Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow"
	TARGET=zx81 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81 -x$(OUTPUT_DIRECTORY)/gfx81 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81.lst
	@echo ''
	@echo '--- Building ZX81 Pseudo-HR Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow" SUBTYPE=zx81phrg
	TARGET=zx81phrg TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81phrg -x$(OUTPUT_DIRECTORY)/gfx81phrg @$(LISTFILE_DIRECTORY)/target/zx81/gfx81phrg.lst
	$(MAKE) zx81deps

# Lambda 8300 graphics lib - Stefano
gfxlambda.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow" SUBTYPE=lambda
	TARGET=lambda TYPE=ixiy $(LIBLINKER) -IXIY -DFORlambda -x$(OUTPUT_DIRECTORY)/gfxlambda @$(LISTFILE_DIRECTORY)/target/zx81/gfx81.lst
	$(MAKE) zx81deps

# ZX81 UDG based graphics lib - Stefano
gfx81udg.lib:
	@echo ''
	@echo '--- Building ZX81 UDG based Graphics Library ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 SUBTYPE=zx81udg FLAVOUR="narrow text6"
	TARGET=zx81udg TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81udg -x$(OUTPUT_DIRECTORY)/gfx81udg @$(LISTFILE_DIRECTORY)/target/zx81/gfx81udg.lst
	$(MAKE) zx81deps

# ZX81 HR graphics lib - Stefano
gfx81hr64.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (64 rows)  ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81hr64
	TARGET=zx81hr64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr64 -x$(OUTPUT_DIRECTORY)/gfx81hr64 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81hr.lst
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81hr64
	TARGET=zx81hr64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr64 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx64 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81arx.lst
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81mt64
	TARGET=zx81mt64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81mt64 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt64 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81mt.lst
	$(MAKE) zx81deps

gfx81hr192.lib:
	@echo ''
	@echo '--- Building ZX81 High Resolution Libraries (192 rows)  ---'
	@echo ''
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81hr192
	TARGET=zx81hr192 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr192 -x$(OUTPUT_DIRECTORY)/gfx81hr192 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81hr.lst
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81hr192
	TARGET=zx81hr192 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr192 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx192 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81arx.lst
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81mt192
	TARGET=zx81mt192 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81mt192 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt192 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81mt.lst
	$(MAKE) zx81deps
	$(MAKE) -C gfx TARGET=zx81 FLAVOUR="narrow gray" SUBTYPE=zx81g007
	TARGET=zx81g007 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81g007 -DG007 -x$(OUTPUT_DIRECTORY)/gfx81g007 @$(LISTFILE_DIRECTORY)/target/zx81/gfx81g007.lst
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
ti82_clib.lib:
	@echo ''
	@echo '--- Building TI82 Library ---'
	@echo ''
	$(MAKE) -C target/ticalc clean
	$(call buildgeneric,ti82,"gray narrow")
	$(RM) games/ticalc/*.o
	$(MAKE) -C games TARGET=ti82
	TARGET=ti82 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti82 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti82_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83_clib.lib:
	@echo ''
	@echo '--- Building TI83 Library ---'
	@echo ''
	$(MAKE) -C target/ticalc clean
	$(call buildgeneric,ti83,"gray narrow")
	$(RM) -f games/ticalc/*.o
	$(MAKE) -C games TARGET=ti83
	TARGET=ti83 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti83 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti83p_clib.lib:
	@echo ''
	@echo '--- Building TI83+ Library ---'
	@echo ''
	$(MAKE) -C target/ticalc clean
	$(call buildgeneric,ti8x,"gray narrow")
	$(RM) -f games/ticalc/*.o
	$(MAKE) -C games TARGET=ti8x
	TARGET=ti8x TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti83p -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83p_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti85_clib.lib:
	@echo ''
	@echo '--- Building TI85 Library ---'
	@echo ''
	$(MAKE) -C target/ticalc clean
	$(call buildgeneric,ti85,"gray narrow")
	$(RM) -f games/ticalc/*.o
	$(MAKE) -C games TARGET=ti85
	TARGET=ti85 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti85 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti85_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

ti86_clib.lib:
	@echo ''
	@echo '--- Building TI86 Library ---'
	@echo ''
	$(MAKE) -C target/ticalc clean
	$(call buildgeneric,ti86,"gray narrow")
	$(RM) -f games/ticalc/*.o
	$(MAKE) -C games TARGET=ti86
	TARGET=ti86 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti86 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti86_clib @$(LISTFILE_DIRECTORY)/ticalc.lst

# vt100 C lib for the Sharp OZ family - stefano
# use -DPACKEDFONT for tiny 50->80 column modes
ozansi_clib.lib:
	@echo ''
	@echo '--- Building Sharp OZ family ANSI Library ---'
	@echo ''
	$(call buildgeneric,oz)
	$(MAKE) -C target/oz 
	$(MAKE) -C games TARGET=oz
	TARGET=oz TYPE=z80 $(LIBLINKER) -DFORoz -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ozansi_clib @$(LISTFILE_DIRECTORY)/ozansi.lst

# CPM lib - Stefano/dom

gfxkp.lib:
	@echo ''
	@echo '--- Building Kaypro graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=cpm FLAVOUR=narrow SUBTYPE=kaypro
	TARGET=kaypro TYPE=z80 $(LIBLINKER) -DFORkaypro -x$(OUTPUT_DIRECTORY)/gfxkp @$(LISTFILE_DIRECTORY)/target/kaypro84/gfxkp.lst
	$(MAKE) -C gfx TARGET=cpm FLAVOUR=narrow SUBTYPE=kaypro83
	TARGET=kaypro83 TYPE=z80 $(LIBLINKER) -DFORkaypro83 -I$(Z88DK_LIB) -x$(OUTPUT_DIRECTORY)/gfxkp83 @$(LISTFILE_DIRECTORY)/target/kaypro83/gfxkp83.lst

attache.lib:
	@echo ''
	@echo '--- Building Otrona Attache Library ---'
	@echo ''
	$(MAKE) -C psg TARGET=cpm SUBTYPE=attache
	$(MAKE) -C gfx TARGET=cpm FLAVOUR=wide SUBTYPE=attache
	TARGET=attache TYPE=z80 $(LIBLINKER) -DFORattache -x$(OUTPUT_DIRECTORY)/attache @$(LISTFILE_DIRECTORY)/target/attache/attache.lst

bondwell.lib:
	@echo ''
	@echo '--- Building Bondwell 12/14 Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(MAKE) -C games TARGET=cpm SUBTYPE=bondwell
	$(MAKE) -C gfx TARGET=cpm FLAVOUR="gencon narrow" SUBTYPE=bondwell
	TARGET=bondwell TYPE=z80 $(LIBLINKER) -DFORbondwell -x$(OUTPUT_DIRECTORY)/bondwell @$(LISTFILE_DIRECTORY)/target/bondwell/bw.lst

bondwell2.lib:
	@echo ''
	@echo '--- Building Bondwell 2 Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=cpm FLAVOUR=wide SUBTYPE=bondwell2
	TARGET=bondwell2 TYPE=z80 $(LIBLINKER) -DFORbondwell2 -x$(OUTPUT_DIRECTORY)/bondwell2 @$(LISTFILE_DIRECTORY)/target/bondwell2/bw2.lst

gfxosborne1.lib:
	@echo ''
	@echo '--- Building Osborne 1 graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=cpm FLAVOUR=narrow SUBTYPE=osborne1
	TARGET=osborne1 TYPE=z80 $(LIBLINKER) -DFORosborne1 -x$(OUTPUT_DIRECTORY)/gfxosborne1 @$(LISTFILE_DIRECTORY)/target/osborne1/gfxosborne1.lst

rc700.lib:
	@echo ''
	@echo '--- Building RC-700 Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=cpm FLAVOUR="gencon narrow" SUBTYPE=rc700
	TARGET=rc700 TYPE=z80 $(LIBLINKER) -DFORrc700 -x$(OUTPUT_DIRECTORY)/rc700 @$(LISTFILE_DIRECTORY)/target/rc700/rc700.lst

x1_cpm.lib:
	@echo ''
	@echo '--- Building Sharp X1 Library ---'
	@echo ''
	$(MAKE) -C target/x1 
	$(MAKE) -C gfx TARGET=cpm FLAVOUR=wide SUBTYPE=x1
	TARGET=x1 TYPE=z80 $(LIBLINKER) -DFORx1 -x$(OUTPUT_DIRECTORY)/x1_cpm @$(LISTFILE_DIRECTORY)/target/x1/x1.lst

cpm_clib.lib: 
	@echo ''
	@echo '--- Building CP/M Library ---'
	@echo ''
	$(call buildgeneric,cpm)
	$(MAKE) -C target/cpm
	TARGET=cpm TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm_clib @$(LISTFILE_DIRECTORY)/cpm.lst

cpm8080_clib.lib:
	@echo ''
	@echo '--- Building CP/M Library (8080)---'
	@echo ''
	$(RM) target/cpm/stdio/*.o target/cpm/cpm/*.o
	TARGET=cpm TYPE=8080 DEVICE=nodevice $(LIBLINKER) -m8080 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm8080_clib @$(LISTFILE_DIRECTORY)/cpm_8080.lst

cpmdevice.lib:
	@echo ''
	@echo '--- Building CP/M Device fnctl Library ---'
	@echo ''
	TARGET=cpm TYPE=z80 DEVICE=device $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpmdevice @target/cpm/fcntl/fcntl.lst

cpmdevice_8080.lib:
	@echo ''
	@echo '--- Building CP/M Device fnctl Library (8080) ---'
	@echo ''
	TARGET=cpm TYPE=8080 DEVICE=device $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpmdevice_8080 @target/cpm/fcntl/fcntl.lst


# Sorcerer Exidy lib - Stefano
srr_clib.lib:
	@echo ''
	@echo '--- Building Sorcerer Exidy Library ---'
	@echo ''
	$(call buildgeneric,srr,"gencon narrow")
	$(MAKE) -C games TARGET=srr
	TARGET=srr TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsorcerer -x$(OUTPUT_DIRECTORY)/srr_clib @$(LISTFILE_DIRECTORY)/srr.lst

# Sharp MZ lib - Stefano
mz_clib.lib:
	@echo ''
	@echo '--- Building Sharp MZ Library ---'
	@echo ''
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
	$(call buildgeneric,abc80)
	$(MAKE) -C games TARGET=abc80 SUBSET=joystick.asm
	TARGET=abc80 TYPE=z80 $(LIBLINKER)  -DFORabc80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc80_clib @$(LISTFILE_DIRECTORY)/abc80.lst

# ABC800 library - Stefano
abc800_clib.lib:
	@echo ''
	@echo '--- Building ABC800 Library ---'
	@echo ''
	$(RM) target/abc80/graphics/*.o
	$(call buildgeneric,abc800)
	$(MAKE) -C games TARGET=abc800 SUBSET=joystick.asm
	TARGET=abc800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc800_clib @$(LISTFILE_DIRECTORY)/abc800.lst

# Jupiter ACE library - Stefano
ace_clib.lib:
	@echo ''
	@echo '--- Building Jupiter Ace Library ---'
	@echo ''
	$(call buildgeneric,ace)
	$(MAKE) -C target/ace 
	$(MAKE) -C games TARGET=ace
	TARGET=ace TYPE=z80 $(LIBLINKER) -DFORace -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/ace_clib.lib @$(LISTFILE_DIRECTORY)/ace.lst

gfxace.lib:
	@echo ''
	@echo '--- Building Jupiter Ace Graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=ace FLAVOUR="text narrow"
	TARGET=ace TYPE=z80 $(LIBLINKER) -DFORace -x$(OUTPUT_DIRECTORY)/gfxace @$(LISTFILE_DIRECTORY)/target/ace/gfxace.lst

gfxaceudg.lib:
	@echo ''
	@echo '--- Building Jupiter Ace UDG based Graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=ace SUBTYPE=aceudg FLAVOUR="text6 narrow"
	TARGET=aceudg TYPE=z80 $(LIBLINKER) -DFORaceudg -x$(OUTPUT_DIRECTORY)/gfxaceudg @$(LISTFILE_DIRECTORY)/target/ace/gfxaceudg.lst

# Mattel Aquarius library - Stefano
aquarius_clib.lib: 
	@echo ''
	@echo '--- Building Mattel Aquarius Library (& 80x72 GFX) ---'
	@echo ''
	$(call buildgeneric,aquarius,"text6 narrow")
	$(MAKE) -C games TARGET=aquarius 
	TARGET=aquarius TYPE=z80 $(LIBLINKER) -DFORaquarius -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/aquarius_clib.lib @$(LISTFILE_DIRECTORY)/aquarius.lst

gfxaq48.lib:
	@echo ''
	@echo '--- Building Mattel Aquarius 80x48 Graphics lib ---'
	@echo ''
	$(MAKE) -C gfx TARGET=aquarius SUBTYPE=aq48 FLAVOUR="text narrow"
	TARGET=aq48 TYPE=z80 $(LIBLINKER) -DFORaq48 -x$(OUTPUT_DIRECTORY)/gfxaq48 @$(LISTFILE_DIRECTORY)/target/aquarius/gfxaq48.lst
	
# Aussie Byte library - Stefano
aussie.lib:
	@echo ''
	@echo '--- Building Aussie Byte Library ---'
	@echo ''
	$(MAKE) -C games TARGET=cpm SUBTYPE=aussie
	$(MAKE) -C gfx TARGET=cpm SUBTYPE=aussie FLAVOUR=wide
	TARGET=aussie TYPE=z80 $(LIBLINKER) -DFORaussie -x$(OUTPUT_DIRECTORY)/aussie.lib @$(LISTFILE_DIRECTORY)/target/aussie/aussie.lst

# Applied Technology MicroBee library - Stefano
bee_clib.lib:
	@echo ''
	@echo '--- Building MicroBee Library ---'
	@echo ''
	$(call buildgeneric,bee,"gencon narrow")
	$(MAKE) -C games TARGET=bee
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/bee_clib.lib @$(LISTFILE_DIRECTORY)/bee.lst

microbee.lib:
	@echo ''
	@echo '--- Building MicroBee Library (CP/M & graphics) ---'
	@echo ''
	$(MAKE) -C games TARGET=bee
	$(MAKE) -C gfx TARGET=bee FLAVOUR="gencon narrow"
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/microbee.lib @$(LISTFILE_DIRECTORY)/target/bee/beecpm.lst
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -x$(OUTPUT_DIRECTORY)/gfxbee.lib @$(LISTFILE_DIRECTORY)/target/bee/beegfx.lst
	$(MAKE) -C gfx TARGET=bee FLAVOUR="wide" SUBTYPE=beehr
	TARGET=beehr TYPE=z80 $(LIBLINKER) -DFORbeehr -x$(OUTPUT_DIRECTORY)/gfxbee640.lib @$(LISTFILE_DIRECTORY)/target/bee/beegfxhr.lst
	$(MAKE) -C gfx TARGET=bee FLAVOUR="wide" SUBTYPE=beehr320
	TARGET=beehr320 TYPE=z80 $(LIBLINKER) -DFORbeehr320 -x$(OUTPUT_DIRECTORY)/gfxbee320.lib @$(LISTFILE_DIRECTORY)/target/bee/beegfxhr320.lst
	$(MAKE) -C gfx TARGET=bee FLAVOUR="wide" SUBTYPE=beehr512
	TARGET=beehr512 TYPE=z80 $(LIBLINKER) -DFORbeehr512 -x$(OUTPUT_DIRECTORY)/gfxbee512.lib @$(LISTFILE_DIRECTORY)/target/bee/beegfxhr512.lst

# Philips Videopac C7420 library - Stefano
c7420_clib.lib:
	@echo ''
	@echo '--- Building Philips Videopac C7420 Library ---'
	@echo ''
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
	$(call buildgeneric,sam)
	$(MAKE) -C games TARGET=sam
	$(MAKE) -C target/zx TARGET=sam
	TARGET=sam TYPE=z80 $(LIBLINKER) -DFORsam -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sam_clib @$(LISTFILE_DIRECTORY)/sam.lst

# Spectravideo SVI library - Stefano
svi_clib.lib:
	@echo ''
	@echo '--- Building Spectravideo Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(call buildgeneric,svi)
	$(MAKE) -C games TARGET=svi
	$(MAKE) -C target/msx/msxbios
	$(MAKE) -C target/svi TARGET=svi
	$(MAKE) -C video/tms9918 TARGET=svi
	$(MAKE) -C psg TARGET=svi
	TARGET=svi TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsvi -x$(OUTPUT_DIRECTORY)/svi_clib @$(LISTFILE_DIRECTORY)/svi.lst
	TARGET=svi TYPE=z80 $(LIBLINKER) -DFORsvi -x$(OUTPUT_DIRECTORY)/svibios @target/svi/arch_svibios.lst

# MSX library - Stefano
msx_clib.lib:
	@echo ''
	@echo '--- Building MSX Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(call buildgeneric,msx)
	$(MAKE) -C target/cpm/fcntl
	$(MAKE) -C games TARGET=msx
	$(MAKE) -C target/msx 
	$(MAKE) -C video/tms9918 TARGET=msx
	$(MAKE) -C psg TARGET=msx
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/msx_clib @$(LISTFILE_DIRECTORY)/msx.lst
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/msxbios @target/msx/arch_msxbios.lst

# MTX library - Stefano
mtx_clib.lib:
	@echo ''
	@echo '--- Building Memotech MTX Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(call buildgeneric,mtx)
	$(MAKE) -C target/mtx
	$(MAKE) -C games TARGET=mtx
	$(MAKE) -C video/tms9918 TARGET=mtx
	TARGET=mtx TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmtx -x$(OUTPUT_DIRECTORY)/mtx_clib @$(LISTFILE_DIRECTORY)/mtx.lst

# Videoton TV Computer library - Sandor
tvc_clib.lib:
	@echo ''
	@echo '--- Building Videoton TV Computer Library ---'
	@echo ''
	$(call buildgeneric,tvc)
	$(MAKE) -C games TARGET=tvc
	$(MAKE) -C target/tvc
	TARGET=tvc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORtvc -x$(OUTPUT_DIRECTORY)/tvc_clib @$(LISTFILE_DIRECTORY)/tvc.lst


# Enterprise library - Stefano
enterprise_clib.lib: 
	@echo ''
	@echo '--- Building Enterprise 64/128 Library ---'
	@echo ''
	$(call buildgeneric,enterprise,wide)
	$(MAKE) -C games TARGET=enterprise
	$(MAKE) -C target/enterprise
	TARGET=enterprise TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORenterprise -x$(OUTPUT_DIRECTORY)/enterprise_clib @$(LISTFILE_DIRECTORY)/enterprise.lst

# Enterprise graphics lib - Stefano
gfxep.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 Graphics Library ---'
	@echo ''
	$(MAKE) -C target/enterprise
	$(MAKE) -C gfx TARGET=enterprise FLAVOUR=wide
	TARGET=enterprise TYPE=z80 $(LIBLINKER) -DFORenterprise -x$(OUTPUT_DIRECTORY)/gfxep @$(LISTFILE_DIRECTORY)/target/enterprise/gfxep.lst

# Enterprise HRG graphics lib - Stefano
gfxephr.lib:
	@echo ''
	@echo '--- Building Enterprise 64/128 High Resolution Graphics Library ---'
	@echo ''
	$(MAKE) -C target/enterprise
	$(MAKE) -C gfx TARGET=enterprise FLAVOUR=wide SUBTYPE=enterprisehr
	TARGET=enterprisehr TYPE=z80 $(LIBLINKER) -DFORenterprisehr -x$(OUTPUT_DIRECTORY)/gfxephr @$(LISTFILE_DIRECTORY)/target/enterprise/gfxephr.lst

# Einstein library - Stefano
einstein.lib:
	@echo ''
	@echo '--- Building Tatung Einstein Library ---'
	@echo ''
	$(MAKE) msxdeps
	@$(RM) -f video/mc6845/*.o
	$(MAKE) -C font
	$(MAKE) -C games TARGET=cpm SUBTYPE=einstein
	$(MAKE) -C video/tms9918 TARGET=cpm SUBTYPE=einstein
	$(MAKE) -C gfx TARGET=cpm FLAVOUR=narrow SUBTYPE=einstein
	$(MAKE) -C psg TARGET=cpm SUBTYPE=einstein
	TARGET=einstein TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFOReinstein -x$(OUTPUT_DIRECTORY)/einstein @$(LISTFILE_DIRECTORY)/target/einstein/einstein.lst

excali64_clib.lib:
	@echo ''
	@echo '--- Building Excalibur 64 Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,excali64,"gencon narrow")
	TARGET=excali64 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORexcali64 -x$(OUTPUT_DIRECTORY)/excali64_clib @$(LISTFILE_DIRECTORY)/excali64_clib.lst
	TARGET=excali64 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORexcali64 -x$(OUTPUT_DIRECTORY)/excali64_cpm @$(LISTFILE_DIRECTORY)/target/excali64/excali64.lst

# SMC-777 library 
smc777_cpm.lib:
	@echo ''
	@echo '--- Building Sony SMC-70/SMC-777 Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(MAKE) -C gfx TARGET=cpm SUBTYPE=smc777 FLAVOUR=wide
	$(MAKE) -C psg TARGET=cpm SUBTYPE=smc777
	$(MAKE) -C games TARGET=cpm SUBTYPE=smc777 TARGET_CFLAGS=-subtype=smc777
	TARGET=smc777 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsmc777 -x$(OUTPUT_DIRECTORY)/smc777_cpm @$(LISTFILE_DIRECTORY)/target/smc777/smc777_cpm.lst

# A5105 library
bic.lib:
	@echo ''
	@echo '--- Building A5105 Library ---'
	@echo ''
	$(MAKE) -C video/upd7220 TARGET=bic
	TARGET=bic TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORbic -x$(OUTPUT_DIRECTORY)/bic @$(LISTFILE_DIRECTORY)/target/bic/bic.lst

# QX10 library
qx10.lib:
	@echo ''
	@echo '--- Building Epsom qx10 Library ---'
	@echo ''
	$(MAKE) -C video/upd7220 TARGET=qx10
	TARGET=qx10 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORqx10 -x$(OUTPUT_DIRECTORY)/qx10 @$(LISTFILE_DIRECTORY)/bic.lst



# Coleco Adam library 
adam.lib:
	@echo ''
	@echo '--- Building Coleco Adam Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=cpm SUBTYPE=coleco
	$(MAKE) -C video/tms9918 TARGET=coleco
	$(MAKE) -C gfx TARGET=coleco FLAVOUR=narrow
	$(MAKE) -C psg TARGET=coleco
	TARGET=coleco TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -DFORadam -x$(OUTPUT_DIRECTORY)/adam @$(LISTFILE_DIRECTORY)/target/adam/adam.lst

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
	$(call buildgeneric,mc1000)
	$(MAKE) -C games TARGET=mc1000
	TARGET=mc1000 TYPE=z80 $(LIBLINKER) -DFORmc1000 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/mc1000_clib @$(LISTFILE_DIRECTORY)/mc1000.lst

# NASCOM library - Stefano
nascom_clib.lib:
	@echo ''
	@echo '--- Building NASCOM Library ---'
	@echo ''
	$(call buildgeneric,nascom,"gencon narrow")
	TARGET=nascom TYPE=z80 $(LIBLINKER) -DFORnascom -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/nascom_clib @$(LISTFILE_DIRECTORY)/nascom.lst
	
# Robotron Z1013 library - Stefano
z1013_clib.lib:
	@echo ''
	@echo '--- Building Robotron Z1013 Library ---'
	@echo ''
	$(call buildgeneric,z1013,"text narrow")
	TARGET=z1013 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz1013 -x$(OUTPUT_DIRECTORY)/z1013_clib @$(LISTFILE_DIRECTORY)/z1013.lst

# Robotron KC85/1, Z9001 library - Stefano
z9001_clib.lib: 
	@echo ''
	@echo '--- Building Robotron KC85/1, KC/87, Z9001 Library ---'
	@echo ''
	$(call buildgeneric,z9001,"text narrow")
	$(MAKE) -C games TARGET=z9001
	TARGET=z9001 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz9001 -x$(OUTPUT_DIRECTORY)/z9001_clib @$(LISTFILE_DIRECTORY)/z9001.lst

gfx9001krt.lib:
	@echo ''
	@echo '--- Building Z9001 KRT High Resolution Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=z9001 SUBTYPE=z9001krt FLAVOUR=wide
	TARGET=z9001krt  TYPE=z80 $(LIBLINKER) -DFORz9001krt -x$(OUTPUT_DIRECTORY)/gfx9001krt @$(LISTFILE_DIRECTORY)/target/z9001/gfx9001krt.lst

# Robotron HC900, KC85/2..KC85/5 library - Stefano
kc_clib.lib:
	@echo ''
	@echo '--- Building VEB Mikroelektronik KC85/2..5 Library ---'
	@echo ''
	$(call buildgeneric,kc,wide)
	TARGET=kc TYPE=ixiy $(LIBLINKER) -IXIY -DSTANDARDESCAPECHARS -DFORkc -x$(OUTPUT_DIRECTORY)/kc_clib @$(LISTFILE_DIRECTORY)/kc.lst

# Hübler/Evert-MC - dom
hemc_clib.lib:
	@echo ''
	@echo '--- Building Hübler/Evert-MC Library ---'
	@echo ''
	$(call buildgeneric,hemc,"gencon narrow")
	TARGET=hemc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhemc -x$(OUTPUT_DIRECTORY)/hemc_clib @$(LISTFILE_DIRECTORY)/hemc.lst

# Kramer-MC - dom
kramermc_clib.lib:
	@echo ''
	@echo '--- Building Kramer-MC Library ---'
	@echo ''
	$(call buildgeneric,kramermc,"gencon narrow")
	TARGET=kramermc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORkramermc -x$(OUTPUT_DIRECTORY)/kramermc_clib @$(LISTFILE_DIRECTORY)/kramermc.lst

# Hübler Grafik MC - dom
hgmc_clib.lib:
	@echo ''
	@echo '--- Building Hübler Grafik MC Library ---'
	@echo ''
	$(call buildgeneric,hgmc)
	TARGET=hgmc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhgmc -x$(OUTPUT_DIRECTORY)/hgmc_clib @$(LISTFILE_DIRECTORY)/hgmc.lst

# Primo A-32/64 - dom
primo_clib.lib:
	@echo ''
	@echo '--- Building Primo A-32/48/64 Library ---'
	@echo ''
	$(call buildgeneric,primo)
	$(MAKE) -C games TARGET=primo
	TARGET=primo TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORprimo -x$(OUTPUT_DIRECTORY)/primo_clib @$(LISTFILE_DIRECTORY)/primo.lst



# Bandai RX78 - dom
rx78_clib.lib:
	@echo ''
	@echo '--- Building Bandai RX78 Library ---'
	@echo ''
	@$(RM) -f games/*.o
	$(call buildgeneric,rx78)
	$(MAKE) -C games TARGET=rx78
	TARGET=rx78 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORrx78 -x$(OUTPUT_DIRECTORY)/rx78_clib @$(LISTFILE_DIRECTORY)/rx78.lst

# Casio FP-1100- dom
fp1100_clib.lib:
	@echo ''
	@echo '--- Building Casio FP-1100 Library ---'
	@echo ''
	$(call buildgeneric,fp1100,wide)
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_clib @$(LISTFILE_DIRECTORY)/fp1100.lst

# Z80 TV Game
z80tvgame_clib.lib:
	@echo ''
	@echo '--- Building Z80 TV Game Library ---'
	@echo ''
	$(call buildgeneric,z80tvgame)
	$(MAKE) -C games TARGET=z80tvgame
	TARGET=z80tvgame TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz80tvgame -x$(OUTPUT_DIRECTORY)/z80tvgame_clib @$(LISTFILE_DIRECTORY)/z80tvgame.lst


# Mitsubishi Multi8 - dom
multi8_clib.lib:
	@echo ''
	@echo '--- Building Mitsubishi Multi8 Library ---'
	@echo ''
	$(call buildgeneric,multi8,wide)
	TARGET=multi8 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmulti8 -x$(OUTPUT_DIRECTORY)/multi8_clib @$(LISTFILE_DIRECTORY)/multi8.lst

# Pasopia7 Multi8 - dom
pasopia7_clib.lib:
	@echo ''
	@echo '--- Building Toshiba Pasopia7 Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,pasopia7,"gencon narrow")
	$(MAKE) -C games TARGET=pasopia7
	TARGET=pasopia7 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpasopia7 -x$(OUTPUT_DIRECTORY)/pasopia7_clib @$(LISTFILE_DIRECTORY)/pasopia7.lst

# VTech VZ700- dom
laser500_clib.lib:
	@echo ''
	@echo '--- Building VTech Laser 350/500/700 Library ---'
	@echo ''
	$(call buildgeneric,laser500,wide)
	$(MAKE) -C games TARGET=laser500
	TARGET=laser500 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORlaser500 -x$(OUTPUT_DIRECTORY)/laser500_clib @$(LISTFILE_DIRECTORY)/laser500.lst

# Dick Smith Super80 - dom
super80_clib.lib:
	@echo ''
	@echo '--- Building Super80 Library ---'
	@echo ''
	$(call buildgeneric,super80,"gencon narrow")
	$(MAKE) -C games TARGET=super80
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_clib @$(LISTFILE_DIRECTORY)/super80.lst

super80_vduem_clib.lib:
	@echo ''
	@echo '--- Building Super80 VDUEM Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,super80,"gencon narrow")
	$(MAKE) -C games TARGET=super80
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_vduem_clib @$(LISTFILE_DIRECTORY)/super80_vduem.lst




# Triumph Adler Alphatronic PC - dom
alphatro_clib.lib:
	@echo ''
	@echo '--- Building Triump Adler Alphatronic PC Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,alphatro,"gencon narrow")
	$(MAKE) -C games TARGET=alphatro
	TARGET=alphatro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORalphatro -x$(OUTPUT_DIRECTORY)/alphatro_clib @$(LISTFILE_DIRECTORY)/alphatro.lst

# SPC-1000 - dom
spc1000_clib.lib:
	@echo ''
	@echo '--- Building Samsung SPC-1000 Library ---'
	@echo ''
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
	$(MAKE) -C games TARGET=pv1000
	$(call buildgeneric,pv1000,"gencon narrow")
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

# Nichibutsu My Vision- dom/stefano
myvision_clib.lib:
	@echo ''
	@echo '--- Building Nichibutsu My Vision Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=myvision
	$(call buildgeneric,myvision)
	$(MAKE) -C games TARGET=myvision
	$(MAKE) -C video/tms9918 TARGET=myvision
	TARGET=myvision TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmyvision -x$(OUTPUT_DIRECTORY)/myvision_clib @$(LISTFILE_DIRECTORY)/myvision.lst

# Bandai Supervision 8000 - dom
sv8000_clib.lib:
	@echo ''
	@echo '--- Building Bandai Supervision 8000 Library ---'
	@echo ''
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
	$(MAKE) -C video/tms9918 TARGET=coleco
	TARGET=coleco TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -x$(OUTPUT_DIRECTORY)/coleco_clib @$(LISTFILE_DIRECTORY)/coleco.lst

# Bit90 (colecovision clone + enhancements) - dom/stefano
bit90.lib:
	@echo ''
	@echo '--- Building Bit-90 Library ---'
	@echo ''
	$(MAKE) -C games TARGET=coleco SUBTYPE=bit90 TARGET_CFLAGS=-subtype=bit90
	TARGET=bit90 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -DFORbit90 -x$(OUTPUT_DIRECTORY)/bit90 @$(LISTFILE_DIRECTORY)/target/bit90/bit90.lst

# Pencil II - dom/stefano
pencil2_clib.lib:
	@echo ''
	@echo '--- Building Pencil II Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=pencil2
	$(call buildgeneric,pencil2)
	$(MAKE) -C video/tms9918 TARGET=pencil2
	TARGET=pencil2 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpencil2 -x$(OUTPUT_DIRECTORY)/pencil2_clib @$(LISTFILE_DIRECTORY)/pencil2.lst

# LM80C - dom/stefano
lm80c_clib.lib:
	@echo ''
	@echo '--- Building LM80-C Library ---'
	@echo ''
	$(MAKE) msxdeps
	$(MAKE) -C games TARGET=lm80c
	$(call buildgeneric,lm80c)
	$(MAKE) -C target/lm80c
	$(MAKE) -C video/tms9918 TARGET=lm80c
	TARGET=lm80c TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORlm80c -x$(OUTPUT_DIRECTORY)/lm80c_clib @$(LISTFILE_DIRECTORY)/lm80c.lst


# Genius Leader 2000/4000 - dom
gl_clib.lib:
	@echo ''
	@echo '--- Building Genius Leader 2000/4000 Library ---'
	@echo ''
	$(call buildgeneric,gl)
	$(MAKE) -C games TARGET=gl
	TARGET=gl TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgl -x$(OUTPUT_DIRECTORY)/gl_clib @$(LISTFILE_DIRECTORY)/gl.lst


# Genius Leader 6000 - dom
gl6000_clib.lib:
	@echo ''
	@echo '--- Building Genius Leader 6000 Library ---'
	@echo ''
	$(call buildgeneric,gl)
	TARGET=gl TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgl6000 -x$(OUTPUT_DIRECTORY)/gl6000_clib @$(LISTFILE_DIRECTORY)/gl6000.lst






# Untested C lib for NC100 machines - dom
nc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad NC100 Library ---'
	@echo ''
	$(call buildgeneric,nc)
	$(MAKE) -C target/nc100
	TARGET=nc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnc -x$(OUTPUT_DIRECTORY)/nc_clib @$(LISTFILE_DIRECTORY)/nc100.lst
	
# NC-100 graphics lib - Stefano
gfxnc100.lib:
	@echo ''
	@echo '--- Building NC-100 Graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=nc FLAVOUR="wide"
	TARGET=nc TYPE=z80 $(LIBLINKER) -DFORnc100 -x$(OUTPUT_DIRECTORY)/gfxnc100 @$(LISTFILE_DIRECTORY)/gfxnc.lst
	
gfxzcn.lib:
	@echo ''
	@echo '--- Building NC-100 Graphics Library (ZCN)---'
	@echo ''
	$(MAKE) -C gfx TARGET=nc FLAVOUR="wide" SUBTYPE=zcn
	TARGET=zcn TYPE=z80 $(LIBLINKER) -DFORnc100 -DFORzcn -x$(OUTPUT_DIRECTORY)/gfxzcn @$(LISTFILE_DIRECTORY)/gfxnc.lst

# NC-200 graphics lib - Stefano
gfxnc200.lib:
	@echo ''
	@echo '--- Building NC-200 Graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=nc FLAVOUR="wide" SUBTYPE=nc200
	TARGET=nc200 TYPE=z80 $(LIBLINKER) -DFORnc200 -x$(OUTPUT_DIRECTORY)/gfxnc200 @$(LISTFILE_DIRECTORY)/gfxnc.lst

# Amstrad CPC library - Stefano
cpc_clib.lib:
	@echo ''
	@echo '--- Building Amstrad CPC Library ---'
	@echo ''
	$(call buildgeneric,cpc,wide)
	$(MAKE) -C target/cpc
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcpc -x$(OUTPUT_DIRECTORY)/cpc_clib @$(LISTFILE_DIRECTORY)/cpc.lst
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpccpm @$(LISTFILE_DIRECTORY)/target/cpc/cpc_cpm.lst

cpcfs.lib:
	@echo ''
	@echo '--- Building Amstrad CPC fcntl Library ---'
	@echo ''
	$(MAKE) -C target/cpc/fcntl

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
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128cpm @$(LISTFILE_DIRECTORY)/target/c128/c128_cpm.lst
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128ansi_clib @$(LISTFILE_DIRECTORY)/c128ansi.lst

# C128 Base LO-REZ text mode graphics lib - Stefano
gfx128.lib:
	@echo ''
	@echo '--- Building Commodore 128 Base Graphics Library ---'
	@echo ''
	$(RM) target/c128/graphics/*.o
	$(MAKE) -C target/c128
	$(MAKE) -C gfx TARGET=c128 FLAVOUR="text narrow"
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/gfx128 @$(LISTFILE_DIRECTORY)/target/c128/gfx128.lst

# C128 LO-REZ UDG mode graphics lib - Stefano
gfx128udg.lib:
	@echo ''
	@echo '--- Building Commodore 128 UDG Based Graphics Library ---'
	@echo ''
	$(RM) target/c128/graphics/*.o
	$(RM) target/c128/graphics/udg/*.o
	$(MAKE) -C target/c128
	$(MAKE) -C gfx TARGET=c128 FLAVOUR="narrow text6"
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128udg -x$(OUTPUT_DIRECTORY)/gfx128udg @$(LISTFILE_DIRECTORY)/target/c128/gfx128udg.lst

# C128 HRG graphics lib - Stefano
gfx128hr.lib:
	@echo ''
	@echo '--- Building Commodore 128 High Resolution Graphics Library ---'
	@echo ''
	$(RM) target/c128/graphics/*.o
	$(MAKE) -C target/c128
	$(MAKE) -C gfx TARGET=c128 FLAVOUR="wide" SUBTYPE=c128hr
	TARGET=c128hr TYPE=z80 $(LIBLINKER) -DFORc128hr -x$(OUTPUT_DIRECTORY)/gfx128hr @$(LISTFILE_DIRECTORY)/target/c128/gfx128hr.lst

# C128 640x480 HRG graphics lib - Stefano
gfx128hr480.lib:
	@echo ''
	@echo '--- Building Commodore 128 640x480 HRG Library ---'
	@echo ''
	$(RM) target/c128/graphics/*.o
	$(MAKE) -C target/c128
	$(MAKE) -C gfx TARGET=c128 FLAVOUR="wide" SUBTYPE=c128hr480
	TARGET=c128hr480 TYPE=z80 $(LIBLINKER) -DFORc128hr480 -x$(OUTPUT_DIRECTORY)/gfx128hr480 @$(LISTFILE_DIRECTORY)/target/c128/gfx128hr480.lst

# Grundy NewBrain library - Stefano
newbrain_clib.lib:
	@echo ''
	@echo '--- Building Grundy NewBrain Library ---'
	@echo ''
	$(call buildgeneric,newbrain)
	$(MAKE) -C target/newbrain
	TARGET=newbrain TYPE=z80 $(LIBLINKER) -DFORnewbrain -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/newbrain_clib @$(LISTFILE_DIRECTORY)/newbrain_clib.lst
	TARGET=newbrain TYPE=z80 $(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/newbrain_cpm @$(LISTFILE_DIRECTORY)/target/newbrain/newbrain_cpm.lst

# TIKI-100 library - Stefano
tiki100.lib:
	@echo ''
	@echo '--- Building TIKI-100 Library ---'
	@echo ''
	$(call buildgeneric,cpm)
	$(MAKE) -C gfx TARGET=cpm FLAVOUR="wide" SUBTYPE=tiki100
	$(MAKE) -C psg TARGET=cpm SUBTYPE=tiki100
	TARGET=tiki100 TYPE=z80 $(LIBLINKER) -DFORtiki100 -x$(OUTPUT_DIRECTORY)/tiki100 @$(LISTFILE_DIRECTORY)/target/tiki100/tiki100.lst
	
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
	$(call buildgeneric,gal)
	$(MAKE) -C games TARGET=gal
	TARGET=gal TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgal -x$(OUTPUT_DIRECTORY)/gal_clib @$(LISTFILE_DIRECTORY)/gal.lst

# Sharp PC-G8xx/E2xx - Stefano Bodrato
g800_clib.lib:
	@echo ''
	@echo '--- Building Sharp PC-G8xx/E2xx Library ---'
	@echo ''
	$(call buildgeneric,g800)
	$(MAKE) -C games TARGET=g800
	$(RM) target/g800/graphics/*.o
	TARGET=g800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g800_clib @$(LISTFILE_DIRECTORY)/g800.lst
	$(RM) target/g800/graphics/*.o
	TARGET=g800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g850_clib @$(LISTFILE_DIRECTORY)/g850.lst
	TARGET=g800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g850b @$(LISTFILE_DIRECTORY)/g850b.lst

# Camputers Lynx - Stefano Bodrato
lynx_clib.lib:
	@echo ''
	@echo '--- Building Camputers Lynx Library ---'
	@echo ''
	@$(RM) -f video/mc6845/*.o
	$(call buildgeneric,lynx,"gencon narrow")
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
	$(call buildgeneric,gb,"gencon portable")
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
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/trs80_cpm @$(LISTFILE_DIRECTORY)/target/trs80/trs80_cpm.lst

gfxtrs80.lib:
	@echo ''
	@echo '--- Building TRS 80 GFX Libraries ---'
	@echo ''
	$(MAKE) -C gfx TARGET=trs80 FLAVOUR="text6 narrow" 
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/gfxtrs80 @$(LISTFILE_DIRECTORY)/target/trs80/gfxtrs80.lst

gfxeg2000.lib:
	@echo ''
	@echo '--- Building EG2000 GFX Libraries ---'
	@echo ''
	$(MAKE) -C gfx TARGET=trs80 FLAVOUR="narrow" SUBTYPE=eg2000
	TARGET=eg2000 TYPE=z80 $(LIBLINKER) -DFOReg2000 -x$(OUTPUT_DIRECTORY)/gfxeg2000 @$(LISTFILE_DIRECTORY)/target/trs80/gfxeg2000.lst

grafyx3.lib:
	@echo ''
	@echo '--- Building GrafyxSolution (model 3) Libraries ---'
	@echo ''
	$(RM) target/trs80/grafyx/*.o
	$(MAKE) -C gfx TARGET=trs80 FLAVOUR="wide" SUBTYPE=grafyx3
	TARGET=grafyx3 TYPE=z80 $(LIBLINKER) -DFORgrafyx3 -x$(OUTPUT_DIRECTORY)/grafyx3 @$(LISTFILE_DIRECTORY)/target/trs80/grafyx.lst

grafyx4.lib:
	@echo ''
	@echo '--- Building GrafyxSolution (model 4) Libraries ---'
	@echo ''
	$(RM) target/trs80/grafyx/*.o
	$(MAKE) -C gfx TARGET=trs80 FLAVOUR="wide" SUBTYPE=grafyx4
	TARGET=grafyx4 TYPE=z80 $(LIBLINKER) -DFORgrafyx4 -x$(OUTPUT_DIRECTORY)/grafyx4 @$(LISTFILE_DIRECTORY)/target/trs80/grafyx.lst

trsdos.lib:
	$(MAKE) -C target/trs80/fcntl

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
	$(call buildgeneric,x1,wide)
	$(MAKE) -C target/x1 
	TARGET=x1 TYPE=z80 $(LIBLINKER) -DFORx1 -x$(OUTPUT_DIRECTORY)/x1_clib @$(LISTFILE_DIRECTORY)/x1.lst

# Philips VG5000 lib - Joaopa, Stefano
vg5k_clib.lib:
	@echo ''
	@echo '--- Building Philips VG5000 Library ---'
	@echo ''
	$(call buildgeneric,vg5k,"gencon narrow")
	$(MAKE) -C games TARGET=vg5k
	TARGET=vg5k TYPE=ixiy $(LIBLINKER) -IXIY -DFORvg5k -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/vg5k_clib @$(LISTFILE_DIRECTORY)/vg5k.lst

# S-OS (The Sentinel) - Stefano
sos_clib.lib:
	@echo ''
	@echo '--- Building S-OS (The Sentinel) Library ---'
	@echo ''
	$(call buildgeneric,sos)
	$(MAKE) -C target/sos 
	TARGET=sos TYPE=z80 $(LIBLINKER) -DFORsos -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sos_clib.lib @$(LISTFILE_DIRECTORY)/sos.lst

# OSCA / FLOS - Stefano
osca_clib.lib:
	@echo ''
	@echo '--- Building Old School Computer Architecture Library ---'
	@echo ''
	$(call buildgeneric,osca,wide)
	$(MAKE) -C games TARGET=osca
	$(MAKE) -C target/osca
	TARGET=osca TYPE=z80 $(LIBLINKER) -DFORosca -DSTANDARDESCAPECHARS -DSDHC_SUPPORT -x$(OUTPUT_DIRECTORY)/osca_clib.lib @$(LISTFILE_DIRECTORY)/osca.lst

# s1mp3
s1mp3_clib.lib:
	@echo ''
	@echo '--- Building s1mp3 Library ---'
	@echo ''
	$(call buildgeneric,s1mp3)
	$(MAKE) -C target/s1mp3
	TARGET=s1mp3 TYPE=z80 $(LIBLINKER) -DFORs1mp3 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/s1mp3_clib.lib @$(LISTFILE_DIRECTORY)/s1mp3.lst

pmd85_clib.lib:
	@echo ''
	@echo '--- Building pmd85 Library ---'
	@echo ''
	$(call buildgeneric,pmd85,"portable wide")
	$(MAKE) -C games TARGET=pmd85
	TARGET=pmd85 TYPE=8080 $(LIBLINKER) -m8080 -DFORpmd85 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pmd85_clib @$(LISTFILE_DIRECTORY)/pmd85.lst

mikro80_clib.lib:
	@echo ''
	@echo '--- Building Mikro80 Library ---'
	@echo ''
	$(call buildgeneric,mikro80,"gencon portable narrow")
	$(MAKE) -C games TARGET=mikro80
	TARGET=mikro80 TYPE=8080 $(LIBLINKER) -m8080 -DFORmikro80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/mikro80_clib @$(LISTFILE_DIRECTORY)/mikro80.lst


special_clib.lib:
	@echo ''
	@echo '--- Building Specialist Library ---'
	@echo ''
	$(call buildgeneric,special,"wide portable")
	TARGET=special TYPE=8080 $(LIBLINKER) -m8080 -DFORspecial -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/special_clib.lib @$(LISTFILE_DIRECTORY)/special.lst

m100_clib.lib:
	@echo ''
	@echo '--- Building m100 Library ---'
	@echo ''
	$(call buildgeneric,m100,"portable narrow")
	$(MAKE) -C games TARGET=m100
	TARGET=m100 TYPE=8080 $(LIBLINKER) -m8085 -DFORm100 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/m100_clib @$(LISTFILE_DIRECTORY)/m100.lst

vector06c_clib.lib:
	@echo ''
	@echo '--- Building Vector06c Library ---'
	@echo ''
	$(call buildgeneric,vector06c,portable)
	$(MAKE) -C gfx TARGET=vector06c FLAVOUR=wide
	$(MAKE) -C games TARGET=vector06c
	TARGET=vector06c TYPE=8080 $(LIBLINKER) -m8080 -DFORvector06c -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/vector06c_clib @$(LISTFILE_DIRECTORY)/vector06c.lst

lviv_clib.lib:
	@echo ''
	@echo '--- Building PK-01 Lviv/Lvov Library ---'
	@echo ''
	$(call buildgeneric,lviv,"narrow portable")
	$(MAKE) -C games TARGET=lviv
	TARGET=lviv TYPE=8080 $(LIBLINKER) -m8080 -DFORlviv -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/lviv_clib @$(LISTFILE_DIRECTORY)/lviv.lst

altair8800_clib.lib:
	@echo ''
	@echo '--- Building Altair8800 Library ---'
	@echo ''
	$(call buildgeneric,altair8800,portable)
	TARGET=altair8800 TYPE=8080 $(LIBLINKER) -m8080 -DFORaltair8800 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/altair8800_clib @$(LISTFILE_DIRECTORY)/altair8800.lst


dai_clib.lib:
	@echo ''
	@echo '--- Building DAI Library ---'
	@echo ''
	$(call buildgeneric,dai,portable)
	TARGET=dai TYPE=8080 $(LIBLINKER) -m8080 -DFORdai -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/dai_clib @$(LISTFILE_DIRECTORY)/dai.lst

ondra_clib.lib:
	@echo ''
	@echo '--- Building Ondra Library ---'
	@echo ''
	$(call buildgeneric,ondra,wide)
	$(MAKE) -C games TARGET=ondra
	TARGET=ondra TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORondra -x$(OUTPUT_DIRECTORY)/ondra_clib @$(LISTFILE_DIRECTORY)/ondra.lst

# Homelab 3/4 - dom
homelab_clib.lib:
	@echo ''
	@echo '--- Building Homelab Library ---'
	@echo ''
	$(call buildgeneric,homelab,"gencon narrow")
	$(MAKE) -C games TARGET=homelab
	TARGET=homelab TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhomelab -x$(OUTPUT_DIRECTORY)/homelab_clib @$(LISTFILE_DIRECTORY)/homelab.lst

# Homelab2  - dom
homelab2_clib.lib:
	@echo ''
	@echo '--- Building Homelab2 Library ---'
	@echo ''
	$(call buildgeneric,homelab2,"gencon narrow")
	$(MAKE) -C games TARGET=homelab2
	TARGET=homelab2 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhomelab2 -x$(OUTPUT_DIRECTORY)/homelab2_clib @$(LISTFILE_DIRECTORY)/homelab2.lst

krokha_clib.lib:
	@echo ''
	@echo '--- Building Krokha (tiny) Library ---'
	@echo ''
	$(call buildgeneric,krokha,"gencon portable")
	$(MAKE) -C games TARGET=krokha
	TARGET=krokha TYPE=8080 $(LIBLINKER) -DSTANDARDESCAPECHARS -m8080 -DFORkrokha -x$(OUTPUT_DIRECTORY)/krokha_clib @$(LISTFILE_DIRECTORY)/krokha.lst

radio86_clib.lib:
	@echo ''
	@echo '--- Building Radio86 Library ---'
	@echo ''
	$(call buildgeneric,radio86,"gencon portable")
	TARGET=radio86 TYPE=8080 $(LIBLINKER) -DSTANDARDESCAPECHARS -m8080 -DFORradio86 -x$(OUTPUT_DIRECTORY)/radio86_clib @$(LISTFILE_DIRECTORY)/radio86.lst


gfxvti.lib:
	@echo ''
	@echo '--- Building VTI graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=altair8800 SUBTYPE=vti FLAVOUR="gencon portable"
	TARGET=vti TYPE=8080 $(LIBLINKER) -m8080 -DFORvti -x$(OUTPUT_DIRECTORY)/gfxvti @$(LISTFILE_DIRECTORY)/video/vti/video_vti.lst

gfxvio.lib:
	@echo ''
	@echo '--- Building VIO graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=altair8800 SUBTYPE=vio FLAVOUR="gencon portable"
	TARGET=vio TYPE=8080 $(LIBLINKER) -m8080 -DFORvio -x$(OUTPUT_DIRECTORY)/gfxvio @$(LISTFILE_DIRECTORY)/video/vio/video_vio.lst

gfxvdm.lib:
	@echo ''
	@echo '--- Building VDM graphics Library ---'
	@echo ''
	$(MAKE) -C gfx TARGET=altair8800 SUBTYPE=vdm FLAVOUR="gencon portable"
	TARGET=vdm TYPE=8080 $(LIBLINKER) -m8080 -DFORvdm -x$(OUTPUT_DIRECTORY)/gfxvdm @$(LISTFILE_DIRECTORY)/video/vdm/video_vdm.lst


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

z80_crt0.lib:
	@echo ''
	@echo '--- Building z80 crt Library ---'
	@echo ''
	$(call buildcrt)
	TYPE=z80 $(LIBLINKER) -mz80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z80_crt0 @$(LISTFILE_DIRECTORY)/z80.lst

z80iy_crt0.lib:
	@echo ''
	@echo '--- Building ixiy crt Library ---'
	@echo ''
	$(call buildcrt)
	TYPE=ixiy $(LIBLINKER) -mz80 -IXIY -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z80iy_crt0 @$(LISTFILE_DIRECTORY)/z80.lst

8080_crt0.lib:
	@echo ''
	@echo '--- Building 8080 crt Library ---'
	@echo ''
	$(call buildcrt)
	TYPE=8080 $(LIBLINKER) -m8080 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/8080_crt0 @$(LISTFILE_DIRECTORY)/8080.lst

8085_opt.lib:
	@echo ''
	@echo '--- Building 8080 optimised crt routines---'
	@echo ''
	$(MAKE) -C z80_crt0s
	TYPE=8080 $(LIBLINKER) -m8080 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/8085_opt @$(LISTFILE_DIRECTORY)/z80_crt0s/crt0.lst

z180_opt.lib:
	@echo ''
	@echo '--- Building z180 optimised crt routines---'
	@echo ''
	$(MAKE) -C z80_crt0s
	TYPE=z180 $(LIBLINKER) -mz180 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z180_opt @$(LISTFILE_DIRECTORY)/z80_crt0s/crt0.lst

ez80_opt.lib:
	@echo ''
	@echo '--- Building ez80 optimised crt routines---'
	@echo ''
	$(MAKE) -C z80_crt0s
	TYPE=ez80 $(LIBLINKER) -mz80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/ez80_opt @$(LISTFILE_DIRECTORY)/z80_crt0s/crt0.lst

z80n_crt0.lib:
	@echo ''
	@echo '--- Building z80n crt Library ---'
	@echo ''
	$(call buildcrt)
	TYPE=z80n $(LIBLINKER) -mz80n -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z80n_crt0 @$(LISTFILE_DIRECTORY)/z80.lst

gbz80_crt0.lib:
	@echo ''
	@echo '--- Building gbz80 crt Library ---'
	@echo ''
	$(call buildcrt)
	TYPE=gbz80 $(LIBLINKER) -mgbz80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gbz80_crt0 @$(LISTFILE_DIRECTORY)/gbz80.lst


r2k_crt0.lib:
	@echo ''
	@echo '--- Building r2k crt Library ---'
	@echo ''
	$(call buildcrt)
	TYPE=r2k $(LIBLINKER) -mr2k -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/r2k_crt0 @$(LISTFILE_DIRECTORY)/rabbit.lst


clean: classic-clean new-clean

classic-clean:
	$(MAKE) -C assert clean
	$(MAKE) -C ctype clean
	$(MAKE) -C fcntl clean
	$(MAKE) -C math clean
	$(MAKE) -C interrupts clean
	$(MAKE) -C libgen clean
	$(MAKE) -C setjmp clean
	$(MAKE) -C stdio clean
	$(MAKE) -C stdlib clean
	$(MAKE) -C strings clean
	$(MAKE) -C regex clean
	$(MAKE) -C time clean
	$(MAKE) -C z80_crt0s clean
	$(MAKE) -C adt clean
	$(MAKE) -C adt-newlib clean
	$(MAKE) -C alloc clean
	$(MAKE) -C rect clean
	$(MAKE) -C algorithm clean
	$(MAKE) -C debug clean
	$(MAKE) -C lib3d clean
	$(MAKE) -C input clean	
	$(RM) abc80/*.o
	$(RM) abc800/*.o
	$(MAKE) -C psg clean
	$(MAKE) -C threading/preempt clean
	$(MAKE) -C sprites/software/sp1 clean
	$(MAKE) -C sdcard clean
	$(MAKE) -C games clean
	$(MAKE) -C math clean
	$(MAKE) -C compress clean
	$(MAKE) -C font clean
	$(MAKE) -C arch clean
	$(MAKE) -C target clean
	$(MAKE) -C video clean
	$(MAKE) -C gfx clean
	$(RM) *.lib

new-clean:
	$(MAKE) -C _DEVELOPMENT clean

new-install-clean:
	$(MAKE) -C _DEVELOPMENT install-clean

install-clean: classic-clean new-install-clean

install:
	cp $(OUTPUT_DIRECTORY)/*.lib ../lib/clibs

