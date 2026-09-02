# Ah, that'd be nice, a library makefile!
#
# Problems? Contact the person to blame(!) above the section
# for the library
#
# $Id: Makefile $


include Make.config

TARGETS ?= all

TOCREATE =

# $1 = target
# $2 = libs
check_target = $(if $(or $(filter $(1),$(TARGETS)), $(filter all,$(TARGETS))),$(2),)

CPMLIBS = cpm_clib.lib cpmixiy_clib.lib cpmz180_clib.lib cpm8080_clib.lib cpm8085_clib.lib cpmdevice.lib cpmdevice_8080.lib cpmdevice_8085.lib cpmdevice_z180.lib gfxh19.lib gfxh19alt.lib gfxvio.lib gfxgsx.lib
GENLIBS = z80_crt0.lib z80iy_crt0.lib z80n_crt0.lib z180_crt0.lib 8080_crt0.lib 8085_crt0.lib vm1_crt0.lib gbz80_crt0.lib r2ka_crt0.lib r4k_crt0.lib ez80_z80_crt0.lib kc160_crt0.lib math48.lib genmath.lib mbf32.lib mbf64.lib math16.lib math32.lib daimath32.lib am9511.lib gendos.lib ndos.lib fastmath.lib preempt.lib sp1-all
GENLIBS += gfxtek.lib gfxregis.lib

rs232cpc_booster.lib:
	$(MAKE) -C target/cpc/rs232/booster all

rs232cpc_sti.lib:
	$(MAKE) -C target/cpc/rs232/sti all

nbdrv.lib:
	$(MAKE) -C target/newbrain/fcntl all

flosdos.lib:
	$(MAKE) -C target/osca/fcntl/flos all

flosxdos.lib:
	$(MAKE) -C target/osca/fcntl/flosmulti all


TOCREATE := $(call check_target,altair8800,altair8800_clib.lib gfxvti.lib gfxvdm.lib)
TOCREATE += $(call check_target,ace,ace_clib.lib gfxace.lib gfxaceudg.lib)
TOCREATE += $(call check_target,abc80,abc80_clib.lib)
TOCREATE += $(call check_target,abc800,abc800_clib.lib)
TOCREATE += $(call check_target,adam,adam.lib $(CPMLIBS))
TOCREATE += $(call check_target,agon,agon_clib.lib)
TOCREATE += $(call check_target,alphatp2,alphatp2_clib.lib)
TOCREATE += $(call check_target,alphatro,alphatro_clib.lib alphatro_cpm.lib)
TOCREATE += $(call check_target,apple2,apple2.lib $(CPMLIBS))
TOCREATE += $(call check_target,aquarius,aquarius_clib.lib gfxaq48.lib aqplus.lib)
TOCREATE += $(call check_target,attache,attache.lib $(CPMLIBS))
TOCREATE += $(call check_target,aussie,aussie.lib $(CPMLIBS))
TOCREATE += $(call check_target,bee,bee_clib.lib microbee.lib $(CPMLIBS) gfxbee.lib gfxbee640.lib gfxbee320.lib gfxbee512.lib)
TOCREATE += $(call check_target,bic,bic.lib $(CPMLIBS))
TOCREATE += $(call check_target,bit90,bit90.lib coleco_clib.lib)
TOCREATE += $(call check_target,bondwell,bondwell.lib $(CPMLIBS))
TOCREATE += $(call check_target,bondwell2,bondwell2.lib $(CPMLIBS))
TOCREATE += $(call check_target,c128,c128ansi_clib.lib gfx128.lib gfx128udg.lib gfx128hr.lib gfx128hr480.lib c128cpm.lib)
TOCREATE += $(call check_target,c7420,c7420_clib.lib)
TOCREATE += $(call check_target,coleco,coleco_clib.lib)
TOCREATE += $(call check_target,cpc,cpc_clib.lib cpcfs.lib cpc_math.lib cpccpm.lib rs232cpc_booster.lib rs232cpc_sti.lib)
TOCREATE += $(call check_target,cpm,$(CPMLIBS))
TOCREATE += $(call check_target,dai,dai_clib.lib)
TOCREATE += $(call check_target,einstein,einstein.lib einstein256.lib $(CPMLIBS))
TOCREATE += $(call check_target,embedded,embedded_clib.lib)
TOCREATE += $(call check_target,enterprise,enterprise_clib.lib gfxep.lib gfxephr.lib)
TOCREATE += $(call check_target,excali64,excali64_clib.lib $(CPMLIBS) excali64_cpm.lib)
TOCREATE += $(call check_target,fp1100,fp1100_clib.lib fp1100_cpm.lib)
TOCREATE += $(call check_target,g850,g850_clib.lib e200_clib.lib g815_clib.lib g815b.lib g850b.lib)
TOCREATE += $(call check_target,gal,gal_clib.lib)
TOCREATE += $(call check_target,gemini,gemini.lib $(CPMLIBS))
TOCREATE += $(call check_target,gb,gb_clib.lib)
TOCREATE += $(call check_target,gl,gl_clib.lib)
TOCREATE += $(call check_target,gl6000,gl6000_clib.lib)
TOCREATE += $(call check_target,hector,hector1_clib.lib hectorhr_clib.lib)
TOCREATE += $(call check_target,hdos,hdos_clib.lib)
TOCREATE += $(call check_target,hemc,hemc_clib.lib)
TOCREATE += $(call check_target,hgmc,hgmc_clib.lib)
TOCREATE += $(call check_target,homelab,homelab_clib.lib)
TOCREATE += $(call check_target,homelab2,homelab2_clib.lib)
TOCREATE += $(call check_target,kaypro,gfxkp.lib $(CPMLIBS))
TOCREATE += $(call check_target,kaypro83,gfxkp83.lib $(CPMLIBS))
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
TOCREATE += $(call check_target,map1010,map1010.lib)
TOCREATE += $(call check_target,mbc200,mbc200.lib $(CPMLIBS))
TOCREATE += $(call check_target,mc1000,mc1000_clib.lib)
TOCREATE += $(call check_target,micro8085,micro8085_clib.lib)
TOCREATE += $(call check_target,mikro80,mikro80_clib.lib)
TOCREATE += $(call check_target,msx,msx_clib.lib msx2.lib msxbios.lib cpm_msx.lib)
TOCREATE += $(call check_target,mtx,mtx_clib.lib)
TOCREATE += $(call check_target,multi8,multi8_clib.lib)
TOCREATE += $(call check_target,myvision,myvision_clib.lib)
TOCREATE += $(call check_target,mz,mz_clib.lib)
TOCREATE += $(call check_target,mz2500,mz2500_clib.lib)
TOCREATE += $(call check_target,nanos,nanos.lib)
TOCREATE += $(call check_target,nabu,nabu_clib.lib nabu_cpm.lib nabu_int.lib)
TOCREATE += $(call check_target,nascom,nascom_clib.lib nascomcpm.lib)
TOCREATE += $(call check_target,nc,nc_clib.lib gfxnc100.lib gfxzcn.lib gfxnc200.lib)
TOCREATE += $(call check_target,newbrain,newbrain_clib.lib newbrain_cpm.lib nbdrv.lib)
TOCREATE += $(call check_target,northstar,northstar.lib $(CPMLIBS))
TOCREATE += $(call check_target,osborne,gfxosborne1.lib $(CPMLIBS))
TOCREATE += $(call check_target,ondra,ondra_clib.lib)
TOCREATE += $(call check_target,osca,osca_clib.lib flosdos.lib flosxdos.lib)
TOCREATE += $(call check_target,oz,ozansi_clib.lib)
TOCREATE += $(call check_target,p2000,p2000_clib.lib)
TOCREATE += $(call check_target,pacman,pacman_clib.lib)
TOCREATE += $(call check_target,pasopia7,pasopia7_clib.lib)
TOCREATE += $(call check_target,pc6001,pc6001_clib.lib)
TOCREATE += $(call check_target,pc88,pc88_clib.lib)
TOCREATE += $(call check_target,pcw,pcw.lib $(CPMLIBS))
TOCREATE += $(call check_target,pencil2,pencil2_clib.lib)
TOCREATE += $(call check_target,phc20,phc20_clib.lib)
TOCREATE += $(call check_target,phc25,phc25_clib.lib)
TOCREATE += $(call check_target,pk8000,pk8000_clib.lib)
TOCREATE += $(call check_target,pmd85,pmd85_clib.lib)
TOCREATE += $(call check_target,pps,pps_clib.lib)
TOCREATE += $(call check_target,primo,primo_clib.lib)
TOCREATE += $(call check_target,pv1000,pv1000_clib.lib)
TOCREATE += $(call check_target,pv2000,pv2000_clib.lib)
TOCREATE += $(call check_target,px4,px4.lib $(CPMLIBS))
TOCREATE += $(call check_target,px8,px8.lib $(CPMLIBS))
TOCREATE += $(call check_target,radio86,radio86_clib.lib)
TOCREATE += $(call check_target,rcmx000,rcmx000_clib.lib)
TOCREATE += $(call check_target,rc2014,rc2014-8085_clib.lib)
TOCREATE += $(call check_target,rc700,rc700.lib $(CPMLIBS))
TOCREATE += $(call check_target,rex,rex_clib.lib)
TOCREATE += $(call check_target,rx78,rx78_clib.lib)
TOCREATE += $(call check_target,s1mp3,s1mp3_clib.lib)
TOCREATE += $(call check_target,sam,sam_clib.lib sam_cpm.lib)
TOCREATE += $(call check_target,sc3000,sc3000_clib.lib)
TOCREATE += $(call check_target,smc777,smc777_clib.lib smc777_cpm.lib $(CPMLIBS))
TOCREATE += $(call check_target,sms,sms_clib.lib)
TOCREATE += $(call check_target,sol20,sol20_clib.lib)
TOCREATE += $(call check_target,spc1000,spc1000_clib.lib)
TOCREATE += $(call check_target,srr,srr_clib.lib)
TOCREATE += $(call check_target,sos,sos_clib.lib)
TOCREATE += $(call check_target,special,special_clib.lib)
TOCREATE += $(call check_target,super80,super80_clib.lib super80_vduem_clib.lib)
TOCREATE += $(call check_target,sv8000,sv8000_clib.lib)
TOCREATE += $(call check_target,svi,svi_clib.lib svibios.lib)
TOCREATE += $(call check_target,test,test_clib.lib testz180_clib.lib testez80_z80_clib.lib test8080_clib.lib test8085_clib.lib testvm1_clib.lib testrcm_clib.lib testrcm4k_clib.lib testkc160_clib.lib testgbz80_clib.lib)
TOCREATE += $(call check_target,ti82,ti82_clib.lib)
TOCREATE += $(call check_target,ti83,ti83_clib.lib)
TOCREATE += $(call check_target,ti83p,ti83p_clib.lib)
TOCREATE += $(call check_target,ti85,ti85_clib.lib)
TOCREATE += $(call check_target,ti86,ti86_clib.lib)
TOCREATE += $(call check_target,tim011,tim011.lib)
TOCREATE += $(call check_target,tiki100,tiki100.lib $(CPMLIBS))
TOCREATE += $(call check_target,trs80, trs80_clib.lib trsdos.lib gfxtrs80.lib gfxtrs80m2.lib gfxtrs80m4.lib gfxeg2000.lib grafyx4_3.lib grafyx4.lib gfxhrg1.lib trs80_cpm.lib)
TOCREATE += $(call check_target,ts2068, ts2068_clib.lib m2068.lib)
TOCREATE += $(call check_target,tvc,tvc_clib.lib tvc_romgfx.lib)
TOCREATE += $(call check_target,v1050,v1050.lib gfx1050udg.lib $(CPMLIBS))
TOCREATE += $(call check_target,vector06c,vector06c_clib.lib)
TOCREATE += $(call check_target,vg5k,vg5k_clib.lib)
TOCREATE += $(call check_target,vz,vz_clib.lib)
TOCREATE += $(call check_target,x07,x07_clib.lib)
TOCREATE += $(call check_target,x1,x1_clib.lib x1_cpm.lib $(CPMLIBS))
TOCREATE += $(call check_target,x820ii,x820ii.lib $(CPMLIBS))
TOCREATE += $(call check_target,z1013,z1013_clib.lib)
TOCREATE += $(call check_target,z80retro,z80retro_cpm.lib)
TOCREATE += $(call check_target,z80,z80_clib.lib ixiy_clib.lib 8080_clib.lib 8085_clib.lib vm1_clib.lib r2ka_clib.lib r4k_clib.lib kc160_clib.lib)
TOCREATE += $(call check_target,z80tvgame,z80tvgame_clib.lib)
TOCREATE += $(call check_target,z88,z88_clib.lib z88_math.lib)
TOCREATE += $(call check_target,z9001,z9001_clib.lib)
TOCREATE += $(call check_target,zx, zx_clib.lib zxcpm.lib mzx.lib mzx_tiny.lib) 
TOCREATE += $(call check_target,zxvgs, zxvgs.lib)
TOCREATE += $(call check_target,zx80, zx80_clib.lib)
TOCREATE += $(call check_target,zx81, zx81_clib.lib gfx81.lib gfx81udg.lib gfx81hr64.lib gfx81hr128.lib gfx81hr192.lib gfx81hr384.lib m81.lib m81_tiny.lib gfx81phrg.lib gfx81arx64.lib gfx81g064.lib gfx81mt64.lib gfx81arx128.lib gfx81arx192.lib gfx81mt192.lib gfx81g007.lib)
TOCREATE += $(call check_target,zxn, zxn_clib.lib)


TOCREATE += 

OBJS = 
DIRS =
CLEAN = 

all: $(GENLIBS) $(TOCREATE)

dirs: $(DIRS)

.PHONY: dirs

include classic/adt/heap/heap.mak
include classic/adt/linkedlist/linkedlist.mak
include classic/adt/queue/queue.mak
include classic/adt/stack/stack.mak
include adt/adt.mak
include classic/algorithm/AStarSearch/astar.mak
include alloc/balloc/balloc.mak
include classic/alloc/farmalloc/farmalloc.mak
include classic/alloc/malloc-classic/malloc.mak
include alloc/obstack/obstack.mak
include arch/z80/z80.mak
include compress/aplib/aplib.mak
include compress/zx0/zx0.mak
include compress/zx1/zx1.mak
include compress/zx2/zx2.mak
include classic/compress/zx7/zx7.mak
include ctype/ctype.mak
include classic/debug/debug.mak
include error/error.mak
include font/font_4x8/font_4x8.mak
include font/font_8x8/font_8x8.mak
include font/font_8x10/font_8x10.mak
include font/fzx/fzx.mak
include classic/games/games.mak
include classic/gfx/retrofit/retrofit.mak
include classic/gfx/portable/portable.mak
include classic/gfx/gfx.mak
include classic/video/tek401x/tek.mak
include classic/video/regis/regis.mak
include target/alphatro/alphatro.mak
include target/bee/bee.mak
include target/embedded/embedded.mak
include target/excali64/excali64.mak
include target/fp1100/fp1100.mak
include target/nascom/nascom.mak
include target/rc2014/rc2014.mak
include target/rcmx000/rcmx000.mak
include target/smc777/smc777.mak
include target/super80/super80.mak
include target/special/special.mak
include target/z80/z80.mak
include target/phc20/phc20.mak
include target/test/test.mak
include classic/z80_crt0s/z80_crt0s.mak
include classic/gfx/x11/x11.mak
include classic/input/input.mak
include classic/interrupts/common/common.mak
include classic/interrupts/im1/im1.mak
include classic/interrupts/im2/im2.mak
include classic/interrupts/nmi/nmi.mak
include classic/lib3d/lib3d.mak
include inttypes/inttypes.mak
include libgen/libgen.mak
include locale/locale.mak
include math/fix16/fix16.mak
include classic/rect/rect.mak
include regex/regex.mak
include classic/sdcard/sdcard.mak
include setjmp/setjmp.mak
include classic/string/string.mak
include string/string.mak
include classic/stdio/stdio.mak
include classic/stdlib/stdlib.mak
include time/time.mak
include sound/ay/ay.mak
include sound/sn76489/sn76489.mak
include sound/saa1099/saa1099.mak

# To be replaced with a wildcard include at some point
include target/abc80/abc80.mak
include target/abc800/abc800.mak
include target/ace/ace.mak
include target/adam/adam.mak
include target/aquarius/aquarius.mak
include target/agon/agon.mak
include target/alphatp2/alphatp2.mak
include target/altair8800/altair8800.mak
include target/apple2/apple2.mak
include target/attache/attache.mak
include target/aussie/aussie.mak
include target/bic/bic.mak
include target/bit90/bit90.mak
include target/bondwell/bondwell.mak
include target/bondwell2/bondwell2.mak
include target/c7420/c7420.mak
include target/c128/c128.mak
include target/coleco/coleco.mak
include target/cpc/cpc.mak
include target/cpm/cpm.mak
include target/dai/dai.mak
include target/einstein/einstein.mak
include target/enterprise/enterprise.mak
include target/gal/gal.mak
include target/gb/gb.mak
include target/gemini/gemini.mak
include target/gl/gl.mak
include target/gl6000/gl6000.mak
include target/g800/g800.mak
include target/hector/hector.mak
include target/hdos/hdos.mak
include target/hemc/hemc.mak
include target/hgmc/hgmc.mak
include target/homelab/homelab.mak
include target/homelab2/homelab2.mak
include target/kaypro83/kaypro83.mak
include target/kaypro84/kaypro84.mak
include target/kc/kc.mak
include target/kramermc/kramermc.mak
include target/krokha/krokha.mak
include target/laser500/laser500.mak
include target/lm80c/lm80c.mak
include target/lviv/lviv.mak
include target/lynx/lynx.mak
include target/m100/m100.mak
include target/m5/m5.mak
include target/map1010/map1010.mak
include target/mc1000/mc1000.mak
include target/micro8085/micro8085.mak
include target/msx/msx.mak
include target/svi/svi.mak
include target/mikro80/mikro80.mak
include target/mtx/mtx.mak
include target/multi8/multi8.mak
include target/myvision/myvision.mak
include target/mz/mz.mak
include target/mz2500/mz2500.mak
include target/nc/nc.mak
include target/nabu/nabu.mak
include target/newbrain/newbrain.mak
include target/nanos/nanos.mak
include target/northstar/northstar.mak
include target/ondra/ondra.mak
include target/oz/oz.mak
include target/osca/osca.mak
include target/osborne1/osborne1.mak
include target/p2000/p2000.mak
include target/pacman/pacman.mak
include target/pasopia7/pasopia7.mak
include target/pc6001/pc6001.mak
include target/pc88/pc88.mak
include target/pcw/pcw.mak
include target/pencil2/pencil2.mak
include target/phc25/phc25.mak
include target/pk8000/pk8000.mak
include target/pmd85/pmd85.mak
include target/pps/pps.mak
include target/primo/primo.mak
include target/pv1000/pv1000.mak
include target/pv2000/pv2000.mak
include target/px4/px4.mak
include target/px8/px8.mak
include target/radio86/radio86.mak
include target/rc700/rc700.mak
include target/rex/rex.mak
include target/rx78/rx78.mak
include target/s1mp3/s1mp3.mak
include target/sam/sam.mak
include target/sc3000/sc3000.mak
include target/sms/sms.mak
include target/sol20/sol20.mak
include target/sos/sos.mak
include target/spc1000/spc1000.mak
include target/srr/srr.mak
include target/sv8000/sv8000.mak
include target/tim011/tim011.mak
include target/ts2068/ts2068.mak
include target/ticalc/ticalc.mak
include target/trs80/trs80.mak
include target/tvc/tvc.mak
include target/vector06c/vector06c.mak
include target/vg5k/vg5k.mak
include target/vz/vz.mak
include target/x820/x820.mak
include target/x1/x1.mak
include target/x07/x07.mak
include target/z1013/z1013.mak
include target/z80tvgame/z80tvgame.mak
include target/z88/z88.mak
include target/z9001/z9001.mak
include target/zx/zx.mak
include target/zx81/zx81.mak
include target/zx80/zx80.mak
include target/zxn/zxn.mak
include target/zxvgs/zxvgs.mak

# Targets depend on some common code + target specific (include stdio in here)
TARGET_CLIB_DEPS = $(STDIO_OBJS) $(X11_OBJS) $(GFXPORTABLE_OBJS) $(RETROFIT_OBJS) $(GAMES_NEWLIB_TARGETS) $(INPUT_OBJS) $(SOUND_SAA1099_TARGETS) $(SOUND_AY_TARGETS) $(SOUND_SN76489_TARGETS) $(TIME_TARGETS)

# Generic maths build - dom, stefano
genmath.lib:
	@echo ''
	@echo '--- Building Z80 Generic Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/genmath

mbf32.lib:
	@echo ''
	@echo '--- Building Microsoft Single Precision Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/mbf32

# math16 build - @feilipu
math16.lib:
	@echo ''
	@echo '--- Building IEEE Half Precision Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/math16

# math32 build - @feilipu
math32.lib:
	@echo ''
	@echo '--- Building IEEE Single Precision Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/math32

mbf64.lib:
	@echo ''
	@echo '--- Building Microsoft Double Precision Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/mbf64

daimath32.lib:
	@echo ''
	@echo '--- Building DAI 32-bit 8080 Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/daimath32

# am9511 build - @feilipu
am9511.lib:
	@echo ''
	@echo '--- Building Am9511 APU Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/am9511


# Math48
math48.lib:
	@echo ''
	@echo '--- Building Z80 math48 Library ---'
	@echo ''
	$(MAKE) -C math/float/math48

# Z88 maths build - dom
z88_math.lib:
	@echo ''
	@echo '--- Building Z88 Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/z88math

ndos.lib:
	$(MAKE) -C classic/fcntl/dummy

gendos.lib:
	$(MAKE) -C classic/fcntl/gen_rnd

# micro8085 library - ahjelm
micro8085_clib.lib: $(TARGET_CLIB_DEPS) $(MICRO8085_TARGETS)
	@echo ''
	@echo '--- Building micro8085 Library ---'
	@echo ''
	TARGET=micro8085 TYPE=8085 $(LIBLINKER) -m8085 -DFORmicro8085 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/micro8085_clib @$(TARGET_DIRECTORY)/micro8085/micro8085.lst

# z88 library - dom
z88_clib.lib: $(TARGET_CLIB_DEPS) $(Z88_TARGETS)
	@echo ''
	@echo '--- Building Z88 Library ---'
	@echo ''
	TARGET=z88 TYPE=z80 $(LIBLINKER) -I$(Z88DK_LIB)/target/z88/def -DSTANDARDESCAPECHARS -DFORz88 -x$(OUTPUT_DIRECTORY)/z88_clib @$(TARGET_DIRECTORY)/z88/z88.lst

# 64/32 column library for ZX Spectrum - dom/stefano
# ansi flags
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
zx_clib.lib: $(TARGET_CLIB_DEPS) $(ZX_TARGETS) $(FZX_TARGETS)
	@echo ''
	@echo '--- Building ZX Spectrum Library ---'
	@echo ''
	$(MAKE) -C target/zx/classic/fcntl TARGET=zx
	$(MAKE) -C target/zx/classic/rs232 TARGET=zx
	TARGET=zx TYPE=z80 $(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS $(COLDEFS) -Itarget/zx/newlib  -x$(OUTPUT_DIRECTORY)/zx_clib @$(TARGET_DIRECTORY)/zx/zx.lst

# zxcpm.lib reuses the objects prepared by zx_clib.lib.
zxcpm.lib:  $(TARGET_CLIB_DEPS) $(ZX_TARGETS) zx_clib.lib
	@echo ''
	@echo '--- Building ZX Spectrum CP/M Library ---'
	@echo ''
	TARGET=zx TYPE=z80 $(LIBLINKER) -DFORzx $(COLDEFS)  -x$(OUTPUT_DIRECTORY)/zxcpm @$(TARGET_DIRECTORY)/zx/zx_cpm.lst

zxn_clib.lib: $(TARGET_CLIB_DEPS) $(ZXN_TARGETS) zx_clib.lib
	@echo ''
	@echo '--- Building ZX Spectrum Next Library ---'
	@echo ''
	TARGET=zxn TYPE=z80n $(LIBLINKER) -mz80n -DFORzxn -DSTANDARDESCAPECHARS $(COLDEFS) -Itarget/zx/newlib -x$(OUTPUT_DIRECTORY)/zxn_clib @$(TARGET_DIRECTORY)/zxn/zxn.lst

# 64/32 column library for TS2068 - dom/stefano/alvin
# use -DROMFONT for a tiny 36 columns mode
# or -DPACKEDFONT for tiny 64->85 column modes
ts2068_clib.lib: $(TARGET_CLIB_DEPS) zxn_clib.lib $(TS2068_TARGETS)
	@echo ''
	@echo '--- Building TS2068 (Spectrum clone) Library ---'
	@echo ''
	TARGET=ts2068 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORzx -DFORts2068 -DA80COL -Itarget/zx/newlib -x$(OUTPUT_DIRECTORY)/ts2068_clib @$(TARGET_DIRECTORY)/ts2068/ts2068.lst

# ZXVGS - yarek
zxvgs.lib: $(ZXVGS_TARGETS)
	@echo ''
	@echo '--- Building ZXVGS Library ---'
	@echo ''
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/zxvgs @$(TARGET_DIRECTORY)/zxvgs/zxvgs.lst

# ZX Spectrum maths library - Stefano
mzx.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/zxmath mzx

mzx_tiny.lib:
	@echo ''
	@echo '--- Building ZX Spectrum Tiny Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/zxmath mzx_tiny

# TS2068 maths library - Stefano
m2068.lib:
	@echo ''
	@echo '--- Building Timex TS2068 Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/zxmath m2068

# PacMan lib - Stefano
pacman_clib.lib: $(TARGET_CLIB_DEPS) $(PACMAN_TARGETS)
	@echo ''
	@echo '--- Building PacMan HW Library ---'
	@echo ''
	TARGET=pacman TYPE=z80 $(LIBLINKER) -DFORpacman -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pacman_clib @$(TARGET_DIRECTORY)/pacman/pacman.lst

# Philips P2000 lib - Stefano
p2000_clib.lib: $(TARGET_CLIB_DEPS) $(P2000_TARGETS)
	@echo ''
	@echo '--- Building Philips P2000 Library ---'
	@echo ''
	TARGET=p2000 TYPE=z80 $(LIBLINKER) -DFORp2000 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/p2000_clib @$(TARGET_DIRECTORY)/p2000/p2000.lst

# PC6001 lib - Stefano
pc6001_clib.lib: $(TARGET_CLIB_DEPS) $(PC6001_TARGETS)
	@echo ''
	@echo '--- Building PC6001 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6847 TARGET=pc6001
	TARGET=pc6001 TYPE=z80 $(LIBLINKER) -DFORpc6001 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc6001_clib @$(TARGET_DIRECTORY)/pc6001/pc6001.lst

# PC8801 lib - Stefano
pc88_clib.lib: $(TARGET_CLIB_DEPS) $(PC88_TARGETS)
	@echo ''
	@echo '--- Building PC8801 Library ---'
	@echo ''
	TARGET=pc88 TYPE=z80 $(LIBLINKER) -DFORpc88 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pc88_clib @$(TARGET_DIRECTORY)/pc88/pc88.lst

# Native for sprinter - dom
pps_clib.lib: $(TARGET_CLIB_DEPS) $(PPS_TARGETS)
	@echo ''
	@echo '--- Building Sprinter Library ---'
	@echo ''
	TARGET=pps TYPE=z80 $(LIBLINKER) -DFORzx -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pps_clib @$(TARGET_DIRECTORY)/pps/pps.lst

# Apple II SoftCard CP/M lib - Stefano
apple2.lib: cpm_clib.lib $(APPLE2_TARGETS)
	@echo ''
	@echo '--- Building Apple II SoftCard Library ---'
	@echo ''
	TARGET=apple2 TYPE=z80 $(LIBLINKER) -DFORapple2 -x$(OUTPUT_DIRECTORY)/apple2 @$(TARGET_DIRECTORY)/apple2/apple2.lst

# Epson PX4 lib - Stefano
px4.lib: cpm_clib.lib $(PX4_TARGETS)
	@echo ''
	@echo '--- Building PX-4/HC-40 Library ---'
	@echo ''
	TARGET=px4 TYPE=z80 $(LIBLINKER) -DFORpx4 -x$(OUTPUT_DIRECTORY)/px4 @$(TARGET_DIRECTORY)/px4/px4.lst

# Epson PX8 lib - Stefano
px8.lib: cpm_clib.lib $(PX8_TARGETS)
	@echo ''
	@echo '--- Building PX-8/Geneva Library ---'
	@echo ''
	TARGET=px8 TYPE=z80 $(LIBLINKER) -DFORpx8 -x$(OUTPUT_DIRECTORY)/px8 @$(TARGET_DIRECTORY)/px8/px8.lst

# Visual 1050 library - Stefano
v1050.lib: cpm_clib.lib gfx1050udg.lib classic/games/obj/.stamp-cpm-v1050 classic/gfx/obj/.stamp-cpm-v1050
	@echo ''
	@echo '--- Building Visual 1050 Library (CP/M) ---'
	@echo ''
	TARGET=v1050 TYPE=z80 $(LIBLINKER) -DFORv1050 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/v1050.lib @$(TARGET_DIRECTORY)/v1050/v1050.lst

gfx1050udg.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-cpm-v1050udg
	@echo ''
	@echo '--- Building Visual 1050 UDG based Graphics Library ---'
	@echo ''
	TARGET=v1050udg TYPE=z80 $(LIBLINKER) -DFORv1050udg -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gfx1050udg.lib @$(TARGET_DIRECTORY)/v1050/gfx1050udg.lst

# VZ200/300 lib - Stefano
vz_clib.lib: $(TARGET_CLIB_DEPS) $(VZ_TARGETS)
	@echo ''
	@echo '--- Building VZ200/300 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6847 TARGET=vz
	TARGET=vz TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORvz -x$(OUTPUT_DIRECTORY)/vz_clib @$(TARGET_DIRECTORY)/vz/vz200.lst


# ZX80 lib - Stefano
zx80_clib.lib: $(TARGET_CLIB_DEPS) $(ZX80_TARGETS)
	@echo ''
	@echo '--- Building ZX80 Library ---'
	@echo ''
	TARGET=zx80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORzx80 -x$(OUTPUT_DIRECTORY)/zx80_clib @$(TARGET_DIRECTORY)/zx80/zx80.lst

# ZX81 lib - Stefano
zx81_clib.lib: $(TARGET_CLIB_DEPS) zx80_clib.lib $(ZX81_BASE_TARGETS)
	@echo ''
	@echo '--- Building ZX81 Library ---'
	@echo ''
	TARGET=zx81 TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS -IXIY -DFORzx81 $(COLDEFS) -x$(OUTPUT_DIRECTORY)/zx81_clib @$(TARGET_DIRECTORY)/zx81/zx81.lst

# Lambda 8300 lib - Stefano
lambda_clib.lib: $(TARGET_CLIB_DEPS) zx81_clib.lib $(LAMBDA_TARGETS)
	@echo ''
	@echo '--- Building Lambda 8300 Library ---'
	@echo ''

	TARGET=zx81 SUBTARGET=lambda TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS -IXIY -DFORlambda -x$(OUTPUT_DIRECTORY)/lambda_clib @$(TARGET_DIRECTORY)/zx81/zx81.lst

# ZX81 std graphics lib - Stefano
gfx81.lib: $(TARGET_CLIB_DEPS) lambda_clib.lib $(GFX81_TARGETS)
	TARGET=zx81 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81 -x$(OUTPUT_DIRECTORY)/gfx81 @$(TARGET_DIRECTORY)/zx81/gfx81.lst
	@touch $@

gfx81phrg.lib: $(TARGET_CLIB_DEPS) lambda_clib.lib $(GFX81PHRG_TARGETS)
	TARGET=zx81phrg TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81phrg -x$(OUTPUT_DIRECTORY)/gfx81phrg @$(TARGET_DIRECTORY)/zx81/gfx81phrg.lst
	@touch $@
# Lambda 8300 graphics lib - Stefano
gfxlambda.lib: $(TARGET_CLIB_DEPS) gfx81.lib $(LAMBDA_TARGETS)
	@echo ''
	@echo '--- Building Lambda 8300 Graphics Library ---'
	@echo ''
	TARGET=lambda TYPE=ixiy $(LIBLINKER) -IXIY -DFORlambda -x$(OUTPUT_DIRECTORY)/gfxlambda @$(TARGET_DIRECTORY)/zx81/gfx81.lst

# ZX81 UDG based graphics lib - Stefano
gfx81udg.lib: $(TARGET_CLIB_DEPS) gfxlambda.lib $(GFX81UDG_TARGETS)
	@echo ''
	@echo '--- Building ZX81 UDG based Graphics Library ---'
	@echo ''
	TARGET=zx81udg TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81udg -x$(OUTPUT_DIRECTORY)/gfx81udg @$(TARGET_DIRECTORY)/zx81/gfx81udg.lst

# ZX81 HR graphics lib - Stefano
gfx81hr64.lib: $(TARGET_CLIB_DEPS) gfx81udg.lib $(GFX81HR64_TARGETS)
	TARGET=zx81hr64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr64 -x$(OUTPUT_DIRECTORY)/gfx81hr64 @$(TARGET_DIRECTORY)/zx81/gfx81hr.lst
	@touch $@

gfx81arx64.lib: $(TARGET_CLIB_DEPS) gfx81udg.lib $(GFX81HR64_TARGETS)
	TARGET=zx81hr64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr64 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx64 @$(TARGET_DIRECTORY)/zx81/gfx81arx.lst
	@touch $@

gfx81g064.lib: $(TARGET_CLIB_DEPS) gfx81udg.lib $(GFX81G64_TARGETS)
	TARGET=zx81g64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81g64 -DG007 -x$(OUTPUT_DIRECTORY)/gfx81g064 @$(TARGET_DIRECTORY)/zx81/gfx81g007.lst
	@touch $@

gfx81mt64.lib: $(TARGET_CLIB_DEPS) gfx81udg.lib $(GFX81MT64_TARGETS)
	TARGET=zx81mt64 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81mt64 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt64 @$(TARGET_DIRECTORY)/zx81/gfx81mt.lst
	@touch $@
gfx81hr128.lib: $(TARGET_CLIB_DEPS) gfx81hr64.lib $(GFX81HR128_TARGETS)
	TARGET=zx81hr128 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr128 -x$(OUTPUT_DIRECTORY)/gfx81hr128 @$(TARGET_DIRECTORY)/zx81/gfx81hr.lst
	@touch $@

gfx81arx128.lib: $(TARGET_CLIB_DEPS) gfx81hr64.lib $(GFX81HR128_TARGETS)
	TARGET=zx81hr128 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr128 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx128 @$(TARGET_DIRECTORY)/zx81/gfx81arx.lst
	@touch $@
gfx81hr192.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81HR192_TARGETS)
	TARGET=zx81hr192 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr192 -x$(OUTPUT_DIRECTORY)/gfx81hr192 @$(TARGET_DIRECTORY)/zx81/gfx81hr.lst
	@touch $@

gfx81arx192.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81HR192_TARGETS)
	TARGET=zx81hr192 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr192 -DARX816 -x$(OUTPUT_DIRECTORY)/gfx81arx192 @$(TARGET_DIRECTORY)/zx81/gfx81arx.lst
	@touch $@

gfx81mt192.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81MT192_TARGETS)
	TARGET=zx81mt192 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81mt192 -DMTHRG -x$(OUTPUT_DIRECTORY)/gfx81mt192 @$(TARGET_DIRECTORY)/zx81/gfx81mt.lst
	@touch $@

gfx81g007.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81G007_TARGETS)
	TARGET=zx81g007 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81g007 -DG007 -x$(OUTPUT_DIRECTORY)/gfx81g007 @$(TARGET_DIRECTORY)/zx81/gfx81g007.lst
	@touch $@

gfx81hr384.lib: $(TARGET_CLIB_DEPS) gfx81hr128.lib $(GFX81HR384_TARGETS)
	TARGET=zx81hr384 TYPE=ixiy $(LIBLINKER) -IXIY -DFORzx81hr384 -x$(OUTPUT_DIRECTORY)/gfx81hr384 @$(TARGET_DIRECTORY)/zx81/gfx81hri.lst
	@touch $@
# ZX81 maths library - Stefano
m81.lib:
	@echo ''
	@echo '--- Building ZX 81 Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/zxmath m81

m81_tiny.lib:
	@echo ''
	@echo '--- Building ZX 81 Tiny Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/zxmath m81_tiny

# Lambda 8300 maths library - Stefano
mlambda.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/zxmath mlambda
	$(MAKE) -C math/float/zxmath mlambdav1
	$(MAKE) -C math/float/zxmath mlambdav3

mlambda_tiny.lib:
	@echo ''
	@echo '--- Building Lambda 8300 Tiny Maths Library ---'
	@echo ''
	$(MAKE) -C math/float/zxmath mlambda_tiny
	$(MAKE) -C math/float/zxmath mlambdav1_tiny
	$(MAKE) -C math/float/zxmath mlambdav3_tiny

# Texas Instrument's calculators: - stefano/henk
# almost the same lib code with different -D flag set
ti82_clib.lib: $(TARGET_CLIB_DEPS) $(TICALC_ti82_TARGETS)
	@echo ''
	@echo '--- Building TI82 Library ---'
	@echo ''
	TARGET=ti82 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti82 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti82_clib @$(TARGET_DIRECTORY)/ticalc/ticalc.lst

ti83_clib.lib: $(TARGET_CLIB_DEPS) $(TICALC_ti83_TARGETS)
	@echo ''
	@echo '--- Building TI83 Library ---'
	@echo ''
	TARGET=ti83 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti83 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83_clib @$(TARGET_DIRECTORY)/ticalc/ticalc.lst

ti83p_clib.lib: $(TARGET_CLIB_DEPS) $(TICALC_ti83p_TARGETS)
	@echo ''
	@echo '--- Building TI83+ Library ---'
	@echo ''
	TARGET=ti83p TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti83p -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti83p_clib @$(TARGET_DIRECTORY)/ticalc/ticalc.lst

ti85_clib.lib: $(TARGET_CLIB_DEPS) $(TICALC_ti85_TARGETS)
	@echo ''
	@echo '--- Building TI85 Library ---'
	@echo ''
	TARGET=ti85 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti85 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti85_clib @$(TARGET_DIRECTORY)/ticalc/ticalc.lst

ti86_clib.lib: $(TARGET_CLIB_DEPS) $(TICALC_ti86_TARGETS)
	@echo ''
	@echo '--- Building TI86 Library ---'
	@echo ''
	TARGET=ti86 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORti86 -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ti86_clib @$(TARGET_DIRECTORY)/ticalc/ticalc.lst

# vt100 C lib for the Sharp OZ family - stefano
# use -DPACKEDFONT for tiny 50->80 column modes
ozansi_clib.lib: $(TARGET_CLIB_DEPS) $(OZ_TARGETS)
	@echo ''
	@echo '--- Building Sharp OZ family ANSI Library ---'
	@echo ''
	TARGET=oz TYPE=z80 $(LIBLINKER) -DFORoz -DPACKEDFONT -x$(OUTPUT_DIRECTORY)/ozansi_clib @$(TARGET_DIRECTORY)/oz/oz.lst

# CPM lib - Stefano/dom

gfxkp.lib: cpm_clib.lib $(TARGET_CLIB_DEPS) $(KAYPRO84_TARGETS)
	@echo ''
	@echo '--- Building Kaypro graphics Library ---'
	@echo ''
	TARGET=kaypro TYPE=z80 $(LIBLINKER) -DFORkaypro -x$(OUTPUT_DIRECTORY)/gfxkp @$(TARGET_DIRECTORY)/kaypro84/gfxkp.lst

gfxkp83.lib: cpm_clib.lib $(KAYPRO83_TARGETS)
	TARGET=kaypro83 TYPE=z80 $(LIBLINKER) -DFORkaypro83 -I$(Z88DK_LIB) -x$(OUTPUT_DIRECTORY)/gfxkp83 @$(TARGET_DIRECTORY)/kaypro83/gfxkp83.lst

attache.lib: cpm_clib.lib $(ATTACHE_TARGETS)
	@echo ''
	@echo '--- Building Otrona Attache Library ---'
	@echo ''
	TARGET=attache TYPE=z80 $(LIBLINKER) -DFORattache -x$(OUTPUT_DIRECTORY)/attache @$(TARGET_DIRECTORY)/attache/attache.lst

bondwell.lib: cpm_clib.lib $(BONDWELL_TARGETS)
	@echo ''
	@echo '--- Building Bondwell 12/14 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6845 TARGET=bondwell
	TARGET=bondwell TYPE=z80 $(LIBLINKER) -DFORbondwell -x$(OUTPUT_DIRECTORY)/bondwell @$(TARGET_DIRECTORY)/bondwell/bw.lst

bondwell2.lib: cpm_clib.lib $(BONDWELL2_TARGETS)
	@echo ''
	@echo '--- Building Bondwell 2 Library ---'
	@echo ''
	$(MAKE) -C classic/video/msm6255 TARGET=cpm SUBTYPE=bondwell2
	TARGET=bondwell2 TYPE=ixiy $(LIBLINKER) -IXIY -DFORbondwell2 -x$(OUTPUT_DIRECTORY)/bondwell2 @$(TARGET_DIRECTORY)/bondwell2/bw2.lst

gfxosborne1.lib: cpm_clib.lib $(TARGET_CLIB_DEPS) $(OSBORNE1_TARGETS)
	@echo ''
	@echo '--- Building Osborne 1 graphics Library ---'
	@echo ''
	TARGET=osborne1 TYPE=z80 $(LIBLINKER) -DFORosborne1 -x$(OUTPUT_DIRECTORY)/gfxosborne1 @$(TARGET_DIRECTORY)/osborne1/gfxosborne1.lst

rc700.lib: cpm_clib.lib $(RC700_TARGETS)
	@echo ''
	@echo '--- Building RC-700 Library ---'
	@echo ''
	TARGET=rc700 TYPE=z80 $(LIBLINKER) -DFORrc700 -x$(OUTPUT_DIRECTORY)/rc700 @$(TARGET_DIRECTORY)/rc700/rc700.lst

x1_cpm.lib: x1_clib.lib $(X1_CPM_TARGETS)
	@echo ''
	@echo '--- Building Sharp X1 Library ---'
	@echo ''
	TARGET=x1 TYPE=z80 $(LIBLINKER) -DFORx1 -x$(OUTPUT_DIRECTORY)/x1_cpm @$(TARGET_DIRECTORY)/x1/x1_common.lst

tim011.lib: cpm_clib.lib $(TIM011_TARGETS)
	@echo ''
	@echo '--- Building Tim-011 Library ---'
	@echo ''
	TARGET=tim011 TYPE=z180 $(LIBLINKER) -mz180 -DFORtim011 -x$(OUTPUT_DIRECTORY)/tim011.lib @$(TARGET_DIRECTORY)/tim011/tim011.lst

x820ii.lib: cpm_clib.lib $(X820_TARGETS)
	@echo ''
	@echo '--- Building Xerox 820 II Library ---'
	@echo ''
	TARGET=x820ii TYPE=z80 $(LIBLINKER) -DFORx820ii -x$(OUTPUT_DIRECTORY)/x820ii.lib @$(TARGET_DIRECTORY)/x820/x820ii.lst

gfxgsx.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-cpm-gsx
	@echo ''
	@echo '--- Building GSX based Z88DK GFX Library ---'
	@echo ''
	TARGET=gsx TYPE=z80 $(LIBLINKER) -DFORcpm -DFORgsx -x$(OUTPUT_DIRECTORY)/gfxgsx @$(TARGET_DIRECTORY)/cpm/gfxgsx.lst
	@touch $@

cpm_clib.lib: $(TARGET_CLIB_DEPS) $(CPM_TARGETS)
	@echo ''
	@echo '--- Building CP/M Library ---'
	@echo ''
	TARGET=cpm TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm_clib @$(TARGET_DIRECTORY)/cpm/cpm.lst

cpmdevice.lib: cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Device fnctl Library ---'
	@echo ''
	TARGET=cpm TYPE=z80 DEVICE=device $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/cpmdevice @$(TARGET_DIRECTORY)/cpm/fcntl/fcntl.lst

cpm8080_clib.lib: $(TARGET_CLIB_DEPS) cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Library (8080)---'
	@echo ''
	TARGET=cpm TYPE=8080 DEVICE=nodevice $(LIBLINKER) -m8080 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm8080_clib @$(TARGET_DIRECTORY)/cpm/cpm_8080.lst

cpmdevice_8080.lib: cpm8080_clib.lib
	@echo ''
	@echo '--- Building CP/M Device fnctl Library (8080) ---'
	@echo ''
	TARGET=cpm TYPE=8080 DEVICE=device $(LIBLINKER) -m8080 -x$(OUTPUT_DIRECTORY)/cpmdevice_8080 @$(TARGET_DIRECTORY)/cpm/fcntl/fcntl.lst

cpm8085_clib.lib: $(TARGET_CLIB_DEPS) cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Library (8085)---'
	@echo ''
	TARGET=cpm TYPE=8085 DEVICE=nodevice $(LIBLINKER) -m8085 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpm8085_clib @$(TARGET_DIRECTORY)/cpm/cpm_8080.lst

cpmdevice_8085.lib: cpm8085_clib.lib
	@echo ''
	@echo '--- Building CP/M Device fnctl Library (8085) ---'
	@echo ''
	TARGET=cpm TYPE=8085 DEVICE=device $(LIBLINKER) -m8085 -x$(OUTPUT_DIRECTORY)/cpmdevice_8085 @$(TARGET_DIRECTORY)/cpm/fcntl/fcntl.lst

cpmixiy_clib.lib: $(TARGET_CLIB_DEPS) cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Library (IXIY)---'
	@echo ''
	TARGET=cpm TYPE=ixiy DEVICE=nodevice $(LIBLINKER) -IXIY -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpmixiy_clib @$(TARGET_DIRECTORY)/cpm/cpm.lst

cpmz180_clib.lib: $(TARGET_CLIB_DEPS) cpm_clib.lib
	@echo ''
	@echo '--- Building CP/M Library (z180)---'
	@echo ''
	TARGET=cpm TYPE=z180 DEVICE=nodevice $(LIBLINKER) -mz180 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/cpmz180_clib @$(TARGET_DIRECTORY)/cpm/cpm.lst

cpmdevice_z180.lib: cpmz180_clib.lib
	@echo ''
	@echo '--- Building CP/M Device fnctl Library (z180) ---'
	@echo ''
	TARGET=cpm TYPE=z180 DEVICE=device $(LIBLINKER) -mz180 -x$(OUTPUT_DIRECTORY)/cpmdevice_z180 @$(TARGET_DIRECTORY)/cpm/fcntl/fcntl.lst

# Sorcerer Exidy lib - Stefano
srr_clib.lib: $(TARGET_CLIB_DEPS) $(SRR_TARGETS)
	@echo ''
	@echo '--- Building Sorcerer Exidy Library ---'
	@echo ''
	TARGET=srr TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsorcerer -x$(OUTPUT_DIRECTORY)/srr_clib @$(TARGET_DIRECTORY)/srr/srr.lst

# Sharp MZ lib - Stefano
mz_clib.lib: $(TARGET_CLIB_DEPS) $(MZ_TARGETS)
	@echo ''
	@echo '--- Building Sharp MZ Library ---'
	@echo ''
	TARGET=mz TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmz -x$(OUTPUT_DIRECTORY)/mz_clib @$(TARGET_DIRECTORY)/mz/mz.lst

# Sharp MZ2500 lib - Stefano
mz2500_clib.lib: $(TARGET_CLIB_DEPS) $(MZ2500_TARGETS)
	@echo ''
	@echo '--- Building Sharp MZ-2500 Library ---'
	@echo ''
	TARGET=mz2500 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmz2500 -x$(OUTPUT_DIRECTORY)/mz2500_clib @$(TARGET_DIRECTORY)/mz2500/mz2500.lst

# ABC80 Library - Stefano
abc80_clib.lib: $(TARGET_CLIB_DEPS) $(ABC80_TARGETS)
	@echo ''
	@echo '--- Building ABC80 Library ---'
	@echo ''
	TARGET=abc80 TYPE=z80 $(LIBLINKER)  -DFORabc80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc80_clib @$(TARGET_DIRECTORY)/abc80/abc80.lst

# ABC800 library - Stefano
abc800_clib.lib: $(TARGET_CLIB_DEPS) $(ABC800_TARGETS)
	@echo ''
	@echo '--- Building ABC800 Library ---'
	@echo ''
	$(RM) target/abc80/graphics/*.o
	TARGET=abc800 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/abc800_clib @$(TARGET_DIRECTORY)/abc800/abc800.lst

# Jupiter ACE library - Stefano
ace_clib.lib: $(TARGET_CLIB_DEPS) $(ACE_TARGETS)
	@echo ''
	@echo '--- Building Jupiter Ace Library ---'
	@echo ''
	TARGET=ace TYPE=z80 $(LIBLINKER) -DFORace -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/ace_clib.lib @$(TARGET_DIRECTORY)/ace/ace.lst

gfxace.lib: $(TARGET_CLIB_DEPS) ace_clib.lib $(ACE_TARGETS)
	@echo ''
	@echo '--- Building Jupiter Ace Graphics Library ---'
	@echo ''
	TARGET=ace TYPE=z80 $(LIBLINKER) -DFORace -x$(OUTPUT_DIRECTORY)/gfxace @$(TARGET_DIRECTORY)/ace/gfxace.lst

gfxaceudg.lib: $(TARGET_CLIB_DEPS) gfxace.lib $(ACEUDG_TARGETS)
	@echo ''
	@echo '--- Building Jupiter Ace UDG based Graphics Library ---'
	@echo ''
	TARGET=aceudg TYPE=z80 $(LIBLINKER) -DFORaceudg -x$(OUTPUT_DIRECTORY)/gfxaceudg @$(TARGET_DIRECTORY)/ace/gfxaceudg.lst

# Mattel Aquarius library - Stefano
aquarius_clib.lib: $(TARGET_CLIB_DEPS) $(AQUARIUS_TARGETS)
	@echo ''
	@echo '--- Building Mattel Aquarius Library (& 80x72 GFX) ---'
	@echo ''
	TARGET=aquarius TYPE=z80 $(LIBLINKER) -DFORaquarius -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/aquarius_clib.lib @$(TARGET_DIRECTORY)/aquarius/aquarius.lst

gfxaq48.lib: $(TARGET_CLIB_DEPS) aquarius_clib.lib classic/gfx/obj/.stamp-aq48
	@echo ''
	@echo '--- Building Mattel Aquarius 80x48 Graphics lib ---'
	@echo ''
	TARGET=aq48 TYPE=z80 $(LIBLINKER) -DFORaq48 -x$(OUTPUT_DIRECTORY)/gfxaq48 @$(TARGET_DIRECTORY)/aquarius/gfxaq48.lst

aqplus.lib: $(TARGET_CLIB_DEPS) aquarius_clib.lib classic/gfx/obj/.stamp-aqplus
	@echo ''
	@echo '--- Building Mattel Aquarius Plus lib ---'
	@echo ''
	TARGET=aqplus TYPE=z80 $(LIBLINKER) -DFORaqplus -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/aqplus @$(TARGET_DIRECTORY)/aquarius/aqplus.lst


# Aussie Byte library - Stefano
aussie.lib: cpm_clib.lib $(AUSSIE_TARGETS)
	@echo ''
	@echo '--- Building Aussie Byte Library ---'
	@echo ''
	TARGET=aussie TYPE=z80 $(LIBLINKER) -DFORaussie -x$(OUTPUT_DIRECTORY)/aussie.lib @$(TARGET_DIRECTORY)/aussie/aussie.lst

# Applied Technology MicroBee library - Stefano
bee_clib.lib: $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee
	@echo ''
	@echo '--- Building MicroBee Library ---'
	@echo ''
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/bee_clib.lib @$(TARGET_DIRECTORY)/bee/bee.lst

# Serialised: microbee.lib runs the same sub-build(s) as bee_clib.lib, into the same obj
# directory. The sub-make is in the recipe, so chaining the library is
# enough to keep the two apart.
microbee.lib:  cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/microbee.lib @$(TARGET_DIRECTORY)/bee/beecpm.lst
	@touch $@

gfxbee.lib:  cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=bee TYPE=z80 $(LIBLINKER) -DFORbee -x$(OUTPUT_DIRECTORY)/gfxbee.lib @$(TARGET_DIRECTORY)/bee/beegfx.lst
	@touch $@

gfxbee640.lib:  gfxbee.lib cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=beehr TYPE=z80 $(LIBLINKER) -DFORbeehr -x$(OUTPUT_DIRECTORY)/gfxbee640.lib @$(TARGET_DIRECTORY)/bee/beegfxhr.lst
	@touch $@

gfxbee320.lib:  gfxbee640.lib cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=beehr320 TYPE=z80 $(LIBLINKER) -DFORbeehr320 -x$(OUTPUT_DIRECTORY)/gfxbee320.lib @$(TARGET_DIRECTORY)/bee/beegfxhr320.lst
	@touch $@

gfxbee512.lib:  gfxbee320.lib cpm_clib.lib bee_clib.lib classic/games/obj/.stamp-bee classic/gfx/obj/.stamp-bee-cpm classic/gfx/obj/.stamp-bee-hr classic/gfx/obj/.stamp-bee-hr320 classic/gfx/obj/.stamp-bee-hr512
	TARGET=beehr512 TYPE=z80 $(LIBLINKER) -DFORbeehr512 -x$(OUTPUT_DIRECTORY)/gfxbee512.lib @$(TARGET_DIRECTORY)/bee/beegfxhr512.lst
	@touch $@
# Gemini Galaxy library - Stefano
gemini.lib: cpm_clib.lib $(GEMINI_TARGETS)
	@echo ''
	@echo '--- Building Gemini Galaxy Library (CP/M & graphics) ---'
	@echo ''
	TARGET=gemini TYPE=z80 $(LIBLINKER) -DFORgemini -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gemini.lib @$(TARGET_DIRECTORY)/gemini/gemini.lst

# Philips Videopac C7420 library - Stefano
c7420_clib.lib: $(TARGET_CLIB_DEPS) $(C7420_TARGETS)
	@echo ''
	@echo '--- Building Philips Videopac C7420 Library ---'
	@echo ''
	TARGET=c7420 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORc7420 -x$(OUTPUT_DIRECTORY)/c7420_clib.lib @$(TARGET_DIRECTORY)/c7420/c7420.lst

# Xircom REX 6000 library - Dominic
rex_clib.lib: $(TARGET_CLIB_DEPS) $(REX_TARGETS)
	@echo ''
	@echo '--- Building Xircom Rex Library ---'
	@echo ''
	TARGET=rex TYPE=z80 $(LIBLINKER) -DFORrex -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/rex_clib.lib @$(TARGET_DIRECTORY)/rex/rex6000.lst

# Sam Coupe library - Stefano & Frode
sam_clib.lib: $(TARGET_CLIB_DEPS) $(SAM_TARGETS)
	@echo ''
	@echo '--- Building Sam Coupe Library ---'
	@echo ''
	TARGET=sam TYPE=z80 $(LIBLINKER) -DFORsam -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sam_clib @$(TARGET_DIRECTORY)/sam/sam.lst

# Serialised: sam_cpm.lib runs the same sub-build(s) as sam_clib.lib, into the same obj
# directory. The sub-make is in the recipe, so chaining the library is
# enough to keep the two apart.
sam_cpm.lib: $(TARGET_CLIB_DEPS) $(SAM_TARGETS) sam_clib.lib
	@echo ''
	@echo '--- Building Sam Coupe CP/M Library ---'
	@echo ''
	TARGET=sam TYPE=z80 $(LIBLINKER) -DFORsam -x$(OUTPUT_DIRECTORY)/sam_cpm @$(TARGET_DIRECTORY)/sam/sam_cpm.lst

# Spectravideo SVI library - Stefano
svi_clib.lib: $(TARGET_CLIB_DEPS) msx_clib.lib $(SVI_TARGETS)
	TARGET=svi TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsvi -x$(OUTPUT_DIRECTORY)/svi_clib @$(TARGET_DIRECTORY)/svi/svi.lst
	@touch $@

svibios.lib: $(TARGET_CLIB_DEPS) msx_clib.lib $(SVI_TARGETS)
	TARGET=svi TYPE=z80 $(LIBLINKER) -DFORsvi -x$(OUTPUT_DIRECTORY)/svibios @$(TARGET_DIRECTORY)/svi/arch_svibios.lst
	@touch $@
# MSX library - Stefano
msx_clib.lib: $(TARGET_CLIB_DEPS) $(MSX_TARGETS)
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/msx_clib @$(TARGET_DIRECTORY)/msx/msx.lst
	@touch $@

msxbios.lib: $(TARGET_CLIB_DEPS) $(MSX_TARGETS)
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/msxbios @$(TARGET_DIRECTORY)/msx/arch_msxbios.lst
	@touch $@

cpm_msx.lib: $(TARGET_CLIB_DEPS) $(MSX_TARGETS)
	TARGET=msx TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx -x$(OUTPUT_DIRECTORY)/cpm_msx @$(TARGET_DIRECTORY)/msx/cpm_msx.lst
	@touch $@

msx2.lib: $(TARGET_CLIB_DEPS) $(MSX2_TARGETS)
	TARGET=msx2 TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmsx2 -x$(OUTPUT_DIRECTORY)/msx2 @$(TARGET_DIRECTORY)/msx/msx2.lst
	@touch $@
# MTX library - Stefano
mtx_clib.lib: $(TARGET_CLIB_DEPS) $(MTX_TARGETS)
	@echo ''
	@echo '--- Building Memotech MTX Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=mtx
	TARGET=mtx TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmtx -x$(OUTPUT_DIRECTORY)/mtx_clib @$(TARGET_DIRECTORY)/mtx/mtx.lst

# Videoton TV Computer library - Sandor
tvc_clib.lib: $(TARGET_CLIB_DEPS) $(TVC_TARGETS)
	@echo ''
	@echo '--- Building Videoton TV Computer Library ---'
	@echo ''
	TARGET=tvc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORtvc -x$(OUTPUT_DIRECTORY)/tvc_clib @$(TARGET_DIRECTORY)/tvc/tvc.lst

# Videoton TV Computer ROM implemented graphics library - Sandor
tvc_romgfx.lib: tvc_clib.lib $(TVCROMGFX_TARGETS)
	@echo ''
	@echo '--- Building Videoton TV Computer ROM based Gfx Library ---'
	@echo ''
	TARGET=tvc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORtvc -x$(OUTPUT_DIRECTORY)/tvc_romgfx @$(TARGET_DIRECTORY)/tvc/tvc_romgfx.lst

# Enterprise library - Stefano
enterprise_clib.lib: $(TARGET_CLIB_DEPS) $(ENTERPRISE_TARGETS)
	@echo ''
	@echo '--- Building Enterprise 64/128 Library ---'
	@echo ''
	TARGET=enterprise TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORenterprise -x$(OUTPUT_DIRECTORY)/enterprise_clib @$(TARGET_DIRECTORY)/enterprise/enterprise.lst

# Enterprise graphics lib - Stefano
gfxep.lib: $(TARGET_CLIB_DEPS) enterprise_clib.lib $(ENTERPRISE_GFX_TARGETS)
	@echo ''
	@echo '--- Building Enterprise 64/128 Graphics Library ---'
	@echo ''
	TARGET=enterprise TYPE=z80 $(LIBLINKER) -DFORenterprise -x$(OUTPUT_DIRECTORY)/gfxep @$(TARGET_DIRECTORY)/enterprise/gfxep.lst

# Enterprise HRG graphics lib - Stefano
gfxephr.lib: $(TARGET_CLIB_DEPS) gfxep.lib $(ENTERPRISE_HRG_TARGETS)
	@echo ''
	@echo '--- Building Enterprise 64/128 High Resolution Graphics Library ---'
	@echo ''
	TARGET=enterprisehr TYPE=z80 $(LIBLINKER) -DFORenterprisehr -x$(OUTPUT_DIRECTORY)/gfxephr @$(TARGET_DIRECTORY)/enterprise/gfxephr.lst

# Einstein library - Stefano
einstein.lib: cpm_clib.lib $(EINSTEIN_TARGETS)
	@echo ''
	@echo '--- Building Tatung Einstein Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=cpm SUBTYPE=einstein
	$(MAKE) -C classic/video/mc6845 TARGET=einstein
	TARGET=einstein TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFOReinstein -x$(OUTPUT_DIRECTORY)/einstein @$(TARGET_DIRECTORY)/einstein/einstein.lst

einstein256.lib: cpm_clib.lib $(EINSTEIN_TARGETS)
	@echo ''
	@echo '--- Building Einstein 256 video Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=cpm SUBTYPE=einstein256
	TARGET=einstein256 TYPE=z80 DEVICE=nodevice $(LIBLINKER) -DSTANDARDESCAPECHARS -DFOReinstein256 -x$(OUTPUT_DIRECTORY)/einstein256 @$(TARGET_DIRECTORY)/einstein/einstein256.lst

excali64_clib.lib:  $(TARGET_CLIB_DEPS) $(EXCALI64_MC6845_OBJECTS) classic/games/obj/.stamp-excali64 classic/gfx/obj/.stamp-excali64
	TARGET=excali64 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORexcali64 -x$(OUTPUT_DIRECTORY)/excali64_clib @$(TARGET_DIRECTORY)/excali64/excali64.lst
	@touch $@

excali64_cpm.lib:  excali64_clib.lib $(TARGET_CLIB_DEPS) $(EXCALI64_MC6845_OBJECTS) classic/games/obj/.stamp-excali64 classic/gfx/obj/.stamp-excali64
	TARGET=excali64 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORexcali64 -x$(OUTPUT_DIRECTORY)/excali64_cpm @$(TARGET_DIRECTORY)/excali64/excali64_cpm.lst
	@touch $@

# SMC-777 library
smc777_clib.lib: $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-smc777 classic/gfx/obj/.stamp-smc777
	@echo ''
	@echo '--- Building Sony SMC-70/SMC-777 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6845 TARGET=smc777
	TARGET=smc777 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsmc777 -x$(OUTPUT_DIRECTORY)/smc777_clib @$(TARGET_DIRECTORY)/smc777/smc777.lst

smc777_cpm.lib: smc777_clib.lib classic/games/obj/.stamp-cpm-smc777 classic/gfx/obj/.stamp-cpm-smc777
	@echo ''
	@echo '--- Building Sony SMC-70/SMC-777 CP/M Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6845 TARGET=smc777
	TARGET=smc777 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsmc777 -x$(OUTPUT_DIRECTORY)/smc777_cpm @$(TARGET_DIRECTORY)/smc777/smc777_cpm.lst

# A5105 library
bic.lib: cpm_clib.lib $(BIC_TARGETS)
	@echo ''
	@echo '--- Building A5105 Library ---'
	@echo ''
	$(MAKE) -C classic/video/upd7220 TARGET=bic
	TARGET=bic TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORbic -x$(OUTPUT_DIRECTORY)/bic @$(TARGET_DIRECTORY)/bic/bic.lst

# QX10 library
qx10.lib: cpm_clib.lib
	@echo ''
	@echo '--- Building Epsom qx10 Library ---'
	@echo ''
	$(MAKE) -C classic/video/upd7220 TARGET=qx10
	TARGET=qx10 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORqx10 -x$(OUTPUT_DIRECTORY)/qx10 @$(TARGET_DIRECTORY)/bic/bic.lst



# Coleco Adam library
adam.lib: coleco_clib.lib $(ADAM_TARGETS)
	@echo ''
	@echo '--- Building Coleco Adam Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=coleco
	TARGET=coleco TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -DFORadam -x$(OUTPUT_DIRECTORY)/adam @$(TARGET_DIRECTORY)/adam/adam.lst

# SORD M5 library - Stefano
m5_clib.lib: $(TARGET_CLIB_DEPS) $(M5_TARGETS)
	@echo ''
	@echo '--- Building SORD M5 Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=m5
	TARGET=m5 TYPE=z80 $(LIBLINKER) -DFORm5 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/m5_clib @$(TARGET_DIRECTORY)/m5/m5.lst

# Sanyo MBC-200 library - Stefano
mbc200.lib: cpm_clib.lib classic/games/obj/.stamp-cpm-mbc200 classic/gfx/obj/.stamp-cpm-mbc200
	@echo ''
	@echo '--- Building Sanyo MBC-200 Library (CP/M) ---'
	@echo ''
	TARGET=mbc200 TYPE=z80 $(LIBLINKER) -DFORmbc200 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/mbc200.lib @$(TARGET_DIRECTORY)/mbc200/mbc200.lst

# MC-1000 library - Stefano
mc1000_clib.lib: $(TARGET_CLIB_DEPS) $(MC1000_TARGETS)
	@echo ''
	@echo '--- Building CCE MC-1000 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6847 TARGET=mc1000
	TARGET=mc1000 TYPE=z80 $(LIBLINKER) -DFORmc1000 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/mc1000_clib @$(TARGET_DIRECTORY)/mc1000/mc1000.lst

# PHC-20 library 
phc20_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-phc20
	@echo ''
	@echo '--- Building Sanyo PHC-20 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6847 TARGET=phc20
	TARGET=phc20 TYPE=z80 $(LIBLINKER) -DFORphc20 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/phc20_clib @$(TARGET_DIRECTORY)/phc20/phc20.lst

# PHC-25 library 
phc25_clib.lib: $(TARGET_CLIB_DEPS) $(PHC25_TARGETS)
	@echo ''
	@echo '--- Building Sanyo PHC-25 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6847 TARGET=phc25
	TARGET=phc25 TYPE=z80 $(LIBLINKER) -DFORphc25 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/phc25_clib @$(TARGET_DIRECTORY)/phc25/phc25.lst

# MAP-1010 override library 
map1010.lib: phc25_clib.lib $(MAP1010_TARGETS)
	@echo ''
	@echo '--- Building Seiko MAP-1010 Library ---'
	@echo ''
	TARGET=phc25 TYPE=z80 $(LIBLINKER) -DFORmap1010 -DSTANDARDESCAPECHARS $(COLDEFS) -x$(OUTPUT_DIRECTORY)/map1010 @$(TARGET_DIRECTORY)/map1010/map1010.lst


# NASCOM library - Stefano
nascom_clib.lib:  $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-nascom classic/gfx/obj/.stamp-nascom
	TARGET=nascom TYPE=z80 $(LIBLINKER) -DFORnascom -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/nascom_clib @$(TARGET_DIRECTORY)/nascom/nascom.lst
	@touch $@

nascomcpm.lib:  $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-nascom classic/gfx/obj/.stamp-nascom
	TARGET=nascom TYPE=z80 $(LIBLINKER) -DFORnascom -DFORnascomcpm -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/nascomcpm @$(TARGET_DIRECTORY)/nascom/nascomcpm.lst
	@touch $@
# Robotron Z1013 library - Stefano
z1013_clib.lib: $(TARGET_CLIB_DEPS) $(Z1013_TARGETS)
	@echo ''
	@echo '--- Building Robotron Z1013 Library ---'
	@echo ''
	$(MAKE) -C classic/video/krt TARGET=z1013
	TARGET=z1013 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz1013 -x$(OUTPUT_DIRECTORY)/z1013_clib @$(TARGET_DIRECTORY)/z1013/z1013.lst

# Robotron KC85/1, Z9001 library - Stefano
z9001_clib.lib: $(TARGET_CLIB_DEPS) $(Z9001_TARGETS)
	@echo ''
	@echo '--- Building Robotron KC85/1, KC/87, Z9001 Library ---'
	@echo ''
	$(MAKE) -C classic/video/krt TARGET=z9001
	TARGET=z9001 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz9001 -x$(OUTPUT_DIRECTORY)/z9001_clib @$(TARGET_DIRECTORY)/z9001/z9001.lst

# Barebone z80 clib
z80_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-z80
	@echo ''
	@echo '--- Building +z80 Library ---'
	@echo ''
	TARGET=z80 TYPE=z80 $(LIBLINKER2) -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/z80_clib @$(TARGET_DIRECTORY)/z80/z80.lst

# Barebone z80 (ixiy swapped)clib
ixiy_clib.lib: $(TARGET_CLIB_DEPS) z80_clib.lib
	@echo ''
	@echo '--- Building +z80 (ixiy) Library ---'
	@echo ''
	TARGET=z80 TYPE=ixiy $(LIBLINKER2) -IXIY -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/ixiy_clib @$(TARGET_DIRECTORY)/z80/z80.lst

# Barebone z80/8080 clib
8080_clib.lib: $(TARGET_CLIB_DEPS) ixiy_clib.lib
	@echo ''
	@echo '--- Building +z80 (8080) Library ---'
	@echo ''
	TARGET=z80 TYPE=8080 $(LIBLINKER2) -m8080 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/8080_clib @$(TARGET_DIRECTORY)/z80/808x.lst

# Barebone z80/8085 clib
8085_clib.lib: $(TARGET_CLIB_DEPS) 8080_clib.lib
	@echo ''
	@echo '--- Building +z80 (8085) Library ---'
	@echo ''
	TARGET=z80 TYPE=8085 $(LIBLINKER2) -m8085 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/8085_clib @$(TARGET_DIRECTORY)/z80/808x.lst

# Barebone z80/vm1 clib
vm1_clib.lib: $(TARGET_CLIB_DEPS) 8085_clib.lib
	@echo ''
	@echo '--- Building +z80 (vm1) Library ---'
	@echo ''
	TARGET=z80 TYPE=vm1 $(LIBLINKER2) -mvm1 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/vm1_clib @$(TARGET_DIRECTORY)/z80/808x.lst

# Barebone z80/r2ka clib
r2ka_clib.lib: $(TARGET_CLIB_DEPS) vm1_clib.lib
	@echo ''
	@echo '--- Building +z80 (r2ka) Library ---'
	@echo ''
	TARGET=z80 TYPE=r2ka $(LIBLINKER2) -mr2ka -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/r2ka_clib @$(TARGET_DIRECTORY)/z80/z80.lst

# Barebone z80/r4k clib
r4k_clib.lib: $(TARGET_CLIB_DEPS) r2ka_clib.lib
	@echo ''
	@echo '--- Building +z80 (r4k) Library ---'
	@echo ''
	TARGET=z80 TYPE=r4k $(LIBLINKER2) -mr4k -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/r4k_clib @$(TARGET_DIRECTORY)/z80/z80.lst

# Barebone z80/kc160 clib
kc160_clib.lib: $(TARGET_CLIB_DEPS) r4k_clib.lib
	@echo ''
	@echo '--- Building +z80 (kc160) Library ---'
	@echo ''
	TARGET=z80 TYPE=kc160 $(LIBLINKER2) -mkc160 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/kc160_clib @$(TARGET_DIRECTORY)/z80/z80.lst

# This re-assembles some files used by the crt0, so make it depend on them
fastmath.lib: kc160_clib.lib
	@echo ''
	@echo '--- Building fast integer maths library ---'
	@echo ''
	$(MAKE) -C math/integer/fastmath


# Robotron HC900, KC85/2..KC85/5 library - Stefano
kc_clib.lib: $(TARGET_CLIB_DEPS) $(KC_TARGETS)
	@echo ''
	@echo '--- Building VEB Mikroelektronik KC85/2..5 Library ---'
	@echo ''
	TARGET=kc TYPE=ixiy $(LIBLINKER) -IXIY -DSTANDARDESCAPECHARS -DFORkc -x$(OUTPUT_DIRECTORY)/kc_clib @$(TARGET_DIRECTORY)/kc/kc.lst

# Heath/Zenith HDOS - Stefano
hdos_clib.lib: $(TARGET_CLIB_DEPS) gfxh19.lib $(HDOS_TARGETS)
	@echo ''
	@echo '--- Building Heath/Zenith HDOS ---'
	@echo ''
	TARGET=hdos TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhdos -x$(OUTPUT_DIRECTORY)/hdos_clib @$(TARGET_DIRECTORY)/hdos/hdos.lst

# Hübler/Evert-MC - dom
hemc_clib.lib: $(TARGET_CLIB_DEPS) $(HEMC_TARGETS)
	@echo ''
	@echo '--- Building Hübler/Evert-MC Library ---'
	@echo ''
	TARGET=hemc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhemc -x$(OUTPUT_DIRECTORY)/hemc_clib @$(TARGET_DIRECTORY)/hemc/hemc.lst

# Kramer-MC - dom
kramermc_clib.lib: $(TARGET_CLIB_DEPS) $(KRAMERMC_TARGETS)
	@echo ''
	@echo '--- Building Kramer-MC Library ---'
	@echo ''
	TARGET=kramermc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORkramermc -x$(OUTPUT_DIRECTORY)/kramermc_clib @$(TARGET_DIRECTORY)/kramermc/kramermc.lst

# Hübler Grafik MC - dom
hgmc_clib.lib: $(TARGET_CLIB_DEPS) $(HGMC_TARGETS)
	@echo ''
	@echo '--- Building Hübler Grafik MC Library ---'
	@echo ''
	TARGET=hgmc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhgmc -x$(OUTPUT_DIRECTORY)/hgmc_clib @$(TARGET_DIRECTORY)/hgmc/hgmc.lst

# Primo A-32/64 - dom
primo_clib.lib: $(TARGET_CLIB_DEPS) $(PRIMO_TARGETS)
	@echo ''
	@echo '--- Building Primo A-32/48/64 Library ---'
	@echo ''
	TARGET=primo TYPE=ixiy $(LIBLINKER) -DSTANDARDESCAPECHARS -IXIY -DFORprimo -x$(OUTPUT_DIRECTORY)/primo_clib @$(TARGET_DIRECTORY)/primo/primo.lst



# Bandai RX78 - dom
rx78_clib.lib: $(TARGET_CLIB_DEPS) $(RX78_TARGETS)
	@echo ''
	@echo '--- Building Bandai RX78 Library ---'
	@echo ''
	TARGET=rx78 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORrx78 -x$(OUTPUT_DIRECTORY)/rx78_clib @$(TARGET_DIRECTORY)/rx78/rx78.lst

# Casio FP-1100- dom
fp1100_clib.lib:  $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-cpm-fp1100 classic/gfx/obj/.stamp-fp1100
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_clib @$(TARGET_DIRECTORY)/fp1100/fp1100.lst
	@touch $@

fp1100_cpm.lib:  fp1100_clib.lib $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-cpm-fp1100 classic/gfx/obj/.stamp-fp1100
	TARGET=fp1100 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORfp1100 -x$(OUTPUT_DIRECTORY)/fp1100_cpm @$(TARGET_DIRECTORY)/fp1100/fp1100_cpm.lst
	@touch $@
# Z80 TV Game
z80tvgame_clib.lib: $(TARGET_CLIB_DEPS) $(Z80TVGAME_TARGETS)
	@echo ''
	@echo '--- Building Z80 TV Game Library ---'
	@echo ''
	TARGET=z80tvgame TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz80tvgame -x$(OUTPUT_DIRECTORY)/z80tvgame_clib @$(TARGET_DIRECTORY)/z80tvgame/z80tvgame.lst


# Mitsubishi Multi8 - dom
multi8_clib.lib: $(TARGET_CLIB_DEPS) $(MULTI8_TARGETS)
	@echo ''
	@echo '--- Building Mitsubishi Multi8 Library ---'
	@echo ''
	TARGET=multi8 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmulti8 -x$(OUTPUT_DIRECTORY)/multi8_clib @$(TARGET_DIRECTORY)/multi8/multi8.lst

# Pasopia7 Multi8 - dom
pasopia7_clib.lib: $(TARGET_CLIB_DEPS) $(PASOPIA7_TARGETS)
	@echo ''
	@echo '--- Building Toshiba Pasopia7 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6845 TARGET=pasopia7
	TARGET=pasopia7 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpasopia7 -x$(OUTPUT_DIRECTORY)/pasopia7_clib @$(TARGET_DIRECTORY)/pasopia7/pasopia7.lst

# VTech VZ700- dom
laser500_clib.lib: $(TARGET_CLIB_DEPS) $(LASER500_TARGETS)
	@echo ''
	@echo '--- Building VTech Laser 350/500/700 Library ---'
	@echo ''
	TARGET=laser500 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORlaser500 -x$(OUTPUT_DIRECTORY)/laser500_clib @$(TARGET_DIRECTORY)/laser500/laser500.lst

# Dick Smith Super80 - dom
super80_clib.lib: $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-super80 classic/gfx/obj/.stamp-super80
	@echo ''
	@echo '--- Building Super80 Library ---'
	@echo ''
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_clib @$(TARGET_DIRECTORY)/super80/super80.lst

super80_vduem_clib.lib: $(TARGET_CLIB_DEPS) super80_clib.lib classic/games/obj/.stamp-super80 classic/gfx/obj/.stamp-super80
	@echo ''
	@echo '--- Building Super80 VDUEM Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6845 TARGET=super80
	TARGET=super80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsuper80 -x$(OUTPUT_DIRECTORY)/super80_vduem_clib @$(TARGET_DIRECTORY)/super80/super80_vduem.lst




# Triumph Adler Alphatronic PC - dom
alphatro_clib.lib:  $(TARGET_CLIB_DEPS) $(ALPHATRO_MC6845_OBJECTS) classic/games/obj/.stamp-alphatro classic/gfx/obj/.stamp-alphatro
	TARGET=alphatro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORalphatro -x$(OUTPUT_DIRECTORY)/alphatro_clib @$(TARGET_DIRECTORY)/alphatro/alphatro.lst
	@touch $@

alphatro_cpm.lib:  alphatro_clib.lib $(TARGET_CLIB_DEPS) $(ALPHATRO_MC6845_OBJECTS) classic/games/obj/.stamp-alphatro classic/gfx/obj/.stamp-alphatro
	TARGET=alphatro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORalphatro -x$(OUTPUT_DIRECTORY)/alphatro_cpm @$(TARGET_DIRECTORY)/alphatro/alphatro_cpm.lst
	@touch $@
# SPC-1000 - dom
spc1000_clib.lib: $(TARGET_CLIB_DEPS) $(SPC1000_TARGETS)
	@echo ''
	@echo '--- Building Samsung SPC-1000 Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=spc1000
	$(MAKE) -C classic/video/mc6847 TARGET=spc1000
	TARGET=spc1000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORspc1000 -x$(OUTPUT_DIRECTORY)/spc1000_clib @$(TARGET_DIRECTORY)/spc1000/spc1000.lst

# Casio PV1000 - dom
pv1000_clib.lib: $(TARGET_CLIB_DEPS) $(PV1000_TARGETS)
	@echo ''
	@echo '--- Building Casio PV-1000 Library ---'
	@echo ''
	TARGET=pv1000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpv1000 -x$(OUTPUT_DIRECTORY)/pv1000_clib @$(TARGET_DIRECTORY)/pv1000/pv1000.lst

# Casio PV2000 - dom/stefano
pv2000_clib.lib: $(TARGET_CLIB_DEPS) $(PV2000_TARGETS)
	@echo ''
	@echo '--- Building Casio PV-2000 Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=pv2000
	TARGET=pv2000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpv2000 -x$(OUTPUT_DIRECTORY)/pv2000_clib @$(TARGET_DIRECTORY)/pv2000/pv2000.lst

# Nichibutsu My Vision- dom/stefano
myvision_clib.lib: $(TARGET_CLIB_DEPS) $(MYVISION_TARGETS)
	@echo ''
	@echo '--- Building Nichibutsu My Vision Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=myvision
	TARGET=myvision TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORmyvision -x$(OUTPUT_DIRECTORY)/myvision_clib @$(TARGET_DIRECTORY)/myvision/myvision.lst

# Bandai Supervision 8000 - dom
sv8000_clib.lib: $(TARGET_CLIB_DEPS) $(SV8000_TARGETS)
	@echo ''
	@echo '--- Building Bandai Supervision 8000 Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6847 TARGET=sv8000
	TARGET=sv8000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORsv8000 -x$(OUTPUT_DIRECTORY)/sv8000_clib @$(TARGET_DIRECTORY)/sv8000/sv8000.lst

# Colecovision - dom/stefano
coleco_clib.lib: $(TARGET_CLIB_DEPS) $(COLECO_TARGETS)
	@echo ''
	@echo '--- Building Colecovision Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=coleco
	TARGET=coleco TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -x$(OUTPUT_DIRECTORY)/coleco_clib @$(TARGET_DIRECTORY)/coleco/coleco.lst

# Bit90 (colecovision clone + enhancements) - dom/stefano
bit90.lib: coleco_clib.lib $(BIT90_TARGETS)
	@echo ''
	@echo '--- Building Bit-90 Library ---'
	@echo ''
	TARGET=bit90 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcoleco -DFORbit90 -x$(OUTPUT_DIRECTORY)/bit90 @$(TARGET_DIRECTORY)/bit90/bit90.lst

# Pencil II - dom/stefano
pencil2_clib.lib: $(TARGET_CLIB_DEPS) $(PENCIL2_TARGETS)
	@echo ''
	@echo '--- Building Pencil II Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=pencil2
	TARGET=pencil2 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORpencil2 -x$(OUTPUT_DIRECTORY)/pencil2_clib @$(TARGET_DIRECTORY)/pencil2/pencil2.lst

# LM80C - dom/stefano
lm80c_clib.lib: $(TARGET_CLIB_DEPS) $(LM80C_TARGETS)
	@echo ''
	@echo '--- Building LM80-C Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=lm80c
	TARGET=lm80c TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORlm80c -x$(OUTPUT_DIRECTORY)/lm80c_clib @$(TARGET_DIRECTORY)/lm80c/lm80c.lst

# NabuPC
nabu_clib.lib: $(TARGET_CLIB_DEPS) $(NABU_TARGETS)
	@echo ''
	@echo '--- Building Nabu Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=nabu
	TARGET=nabu TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnabu -x$(OUTPUT_DIRECTORY)/nabu_clib @$(TARGET_DIRECTORY)/nabu/nabu.lst

nabu_cpm.lib: nabu_clib.lib $(NABU_TARGETS)
	@echo ''
	@echo '--- Building Nabu CP/M Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=nabu
	TARGET=nabu TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnabu -x$(OUTPUT_DIRECTORY)/nabu_cpm @$(TARGET_DIRECTORY)/nabu/nabu_cpm.lst

# Serialised: nabu_int.lib runs the same sub-build(s) as nabu_cpm.lib, into the same obj
# directory. The sub-make is in the recipe, so chaining the library is
# enough to keep the two apart.
nabu_int.lib: nabu_clib.lib nabu_cpm.lib
	@echo ''
	@echo '--- Building Nabu Interrupt Library ---'
	@echo ''
	TARGET=nabu TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnabu -x$(OUTPUT_DIRECTORY)/nabu_int @$(TARGET_DIRECTORY)/nabu/nabu_int.lst

z80retro_cpm.lib: cpm_clib.lib classic/games/obj/.stamp-cpm-z80retro classic/gfx/obj/.stamp-cpm-z80retro
	@echo ''
	@echo '--- Building z80retro! CP/M Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=cpm SUBTYPE=z80retro
	TARGET=z80retro TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORz80retro -x$(OUTPUT_DIRECTORY)/z80retro_cpm @$(TARGET_DIRECTORY)/z80retro/z80retro.lst

# Hector/Victor/Lambda - dom
hector1_clib.lib: $(TARGET_CLIB_DEPS) $(HECTOR_TARGETS)
	@echo ''
	@echo '--- Building Hector/Victor/Lambda Library ---'
	@echo ''
	TARGET=hector1 TYPE=z80 $(LIBLINKER) -mz80 -DSTANDARDESCAPECHARS -DFORhector1 -x$(OUTPUT_DIRECTORY)/hector1_clib @$(TARGET_DIRECTORY)/hector/hector1.lst

# Hector/Victor/Lambda - dom
# Serialised: hectorhr_clib.lib runs the same sub-build(s) as hector1_clib.lib, into the same obj
# directory. The sub-make is in the recipe, so chaining the library is
# enough to keep the two apart.
hectorhr_clib.lib: $(TARGET_CLIB_DEPS) $(HECTOR_TARGETS) hector1_clib.lib
	@echo ''
	@echo '--- Building HectorHR Library ---'
	@echo ''	
	TARGET=hectorhr TYPE=z80 $(LIBLINKER) -mz80 -DSTANDARDESCAPECHARS -DFORhectorhr -x$(OUTPUT_DIRECTORY)/hectorhr_clib @$(TARGET_DIRECTORY)/hector/hector1.lst

# Alphatro P2 - dom
alphatp2_clib.lib: $(TARGET_CLIB_DEPS) $(ALPHATP2_TARGETS)
	@echo ''
	@echo '--- Building Alpha P2 Library ---'
	@echo ''
	TARGET=alphatp2 TYPE=8080 $(LIBLINKER) -m8080 -DSTANDARDESCAPECHARS -DFORalphatp2 -x$(OUTPUT_DIRECTORY)/alphatp2_clib @$(TARGET_DIRECTORY)/alphatp2/alphatp2.lst


# Genius Leader 2000/4000 - dom
gl_clib.lib: $(TARGET_CLIB_DEPS) $(GL_TARGETS)
	@echo ''
	@echo '--- Building Genius Leader 2000/4000 Library ---'
	@echo ''
	TARGET=gl TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgl -x$(OUTPUT_DIRECTORY)/gl_clib @$(TARGET_DIRECTORY)/gl/gl.lst


# Genius Leader 6000 - dom
gl6000_clib.lib: $(TARGET_CLIB_DEPS) gl_clib.lib $(GL6000_TARGETS)
	@echo ''
	@echo '--- Building Genius Leader 6000 Library ---'
	@echo ''
	TARGET=gl6000 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgl6000 -x$(OUTPUT_DIRECTORY)/gl6000_clib @$(TARGET_DIRECTORY)/gl6000/gl6000.lst


# Common Library for Amstrad NC-100/NC-200
nc_clib.lib: $(TARGET_CLIB_DEPS) $(NC_TARGETS)
	@echo ''
	@echo '--- Building Amstrad NC Library ---'
	@echo ''
	TARGET=nc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnc -x$(OUTPUT_DIRECTORY)/nc_clib @$(TARGET_DIRECTORY)/nc/nc.lst

# NC-100 graphics lib - Stefano
gfxnc100.lib: $(TARGET_CLIB_DEPS) nc_clib.lib $(NC100_TARGETS)
	@echo ''
	@echo '--- Building NC-100 Graphics Library ---'
	@echo ''
	TARGET=nc100 TYPE=z80 $(LIBLINKER) -DFORnc100 -x$(OUTPUT_DIRECTORY)/gfxnc100 @$(TARGET_DIRECTORY)/nc/gfxnc.lst

gfxzcn.lib: $(TARGET_CLIB_DEPS) gfxnc100.lib $(ZCN_TARGETS)
	@echo ''
	@echo '--- Building NC-100 Graphics Library (ZCN)---'
	@echo ''
	TARGET=zcn TYPE=z80 $(LIBLINKER) -DFORnc100 -DFORzcn -x$(OUTPUT_DIRECTORY)/gfxzcn @$(TARGET_DIRECTORY)/nc/gfxnc.lst

# NC-200 graphics lib - Stefano
gfxnc200.lib: $(TARGET_CLIB_DEPS) gfxzcn.lib $(NC200_TARGETS)
	@echo ''
	@echo '--- Building NC-200 Graphics Library ---'
	@echo ''
	TARGET=nc200 TYPE=z80 $(LIBLINKER) -DFORnc200 -x$(OUTPUT_DIRECTORY)/gfxnc200 @$(TARGET_DIRECTORY)/nc/gfxnc.lst

# Amstrad CPC library - Stefano
cpc_clib.lib:  $(TARGET_CLIB_DEPS) $(CPC_TARGETS)
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORcpc -x$(OUTPUT_DIRECTORY)/cpc_clib @$(TARGET_DIRECTORY)/cpc/cpc.lst
	@touch $@

cpccpm.lib:  cpc_clib.lib $(TARGET_CLIB_DEPS) $(CPC_TARGETS)
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpccpm @$(TARGET_DIRECTORY)/cpc/cpc_cpm.lst
	@touch $@

cpcfs.lib: $(CPC_FCNTL_OFILES)
	TARGET=cpc TYPE=z80 $(LIBLINKER) -DFORcpc -x$(OUTPUT_DIRECTORY)/cpcfs @$(TARGET_DIRECTORY)/cpc/fcntl/cpcfs.lst
	@touch $@
# Amstrad CPC maths libraries - Dom
cpc_math.lib:
	@echo ''
	@echo '--- Building Amstrad CPC Maths Libraries ---'
	@echo ''
	$(MAKE) -C math/float/cpcmath

# Amstrad PCW libraries - Stefano
pcw.lib: cpm_clib.lib $(PCW_TARGETS)
	@echo ''
	@echo '--- Building Amstrad PCW Library ---'
	@echo ''
	TARGET=pcw TYPE=z80 $(LIBLINKER) -DFORpcw -x$(OUTPUT_DIRECTORY)/pcw @$(TARGET_DIRECTORY)/pcw/pcw.lst

# Commodore 128 (Z80 mode) library - Stefano
c128cpm.lib:  c128ansi_clib.lib $(TARGET_CLIB_DEPS) $(C128_CPM_TARGETS)
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128cpm @$(TARGET_DIRECTORY)/c128/c128_cpm.lst
	@touch $@

c128ansi_clib.lib:  $(TARGET_CLIB_DEPS) $(C128_TARGETS)
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/c128ansi_clib @$(TARGET_DIRECTORY)/c128/c128.lst
	@touch $@
# C128 Base LO-REZ text mode graphics lib - Stefano
gfx128.lib: $(TARGET_CLIB_DEPS) c128ansi_clib.lib $(C128_TARGETS)
	@echo ''
	@echo '--- Building Commodore 128 Base Graphics Library ---'
	@echo ''
	TARGET=c128 TYPE=z80 $(LIBLINKER) -DFORc128 -x$(OUTPUT_DIRECTORY)/gfx128 @$(TARGET_DIRECTORY)/c128/gfx128.lst

# C128 LO-REZ UDG mode graphics lib - Stefano
gfx128udg.lib: $(TARGET_CLIB_DEPS) gfx128.lib $(C128UDG_TARGETS)
	@echo ''
	@echo '--- Building Commodore 128 UDG Based Graphics Library ---'
	@echo ''
	TARGET=c128udg TYPE=z80 $(LIBLINKER) -DFORc128udg -x$(OUTPUT_DIRECTORY)/gfx128udg @$(TARGET_DIRECTORY)/c128/gfx128udg.lst

# C128 HRG graphics lib - Stefano
gfx128hr.lib: $(TARGET_CLIB_DEPS) gfx128udg.lib $(C128HR_TARGETS)
	@echo ''
	@echo '--- Building Commodore 128 High Resolution Graphics Library ---'
	@echo ''
	TARGET=c128hr TYPE=z80 $(LIBLINKER) -DFORc128hr -x$(OUTPUT_DIRECTORY)/gfx128hr @$(TARGET_DIRECTORY)/c128/gfx128hr.lst

# C128 640x480 HRG graphics lib - Stefano
gfx128hr480.lib: $(TARGET_CLIB_DEPS) gfx128hr.lib $(C128HR480_TARGETS)
	@echo ''
	@echo '--- Building Commodore 128 640x480 HRG Library ---'
	@echo ''
	TARGET=c128hr480 TYPE=z80 $(LIBLINKER) -DFORc128hr480 -x$(OUTPUT_DIRECTORY)/gfx128hr480 @$(TARGET_DIRECTORY)/c128/gfx128hr480.lst

# Grundy NewBrain library - Stefano
newbrain_clib.lib:  $(TARGET_CLIB_DEPS) $(NEWBRAIN_TARGETS)
	TARGET=newbrain TYPE=z80 $(LIBLINKER) -DFORnewbrain -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/newbrain_clib @$(TARGET_DIRECTORY)/newbrain/newbrain.lst
	@touch $@

newbrain_cpm.lib:  $(TARGET_CLIB_DEPS) $(NEWBRAIN_TARGETS)
	TARGET=newbrain TYPE=z80 $(LIBLINKER) -DFORnewbrain -x$(OUTPUT_DIRECTORY)/newbrain_cpm @$(TARGET_DIRECTORY)/newbrain/newbrain_cpm.lst
	@touch $@
# Northstar Advantage - Stefano
northstar.lib: cpm_clib.lib $(NORTHSTAR_TARGETS)
	@echo ''
	@echo '--- Building Northstar Advantage graphics Library ---'
	@echo ''
	TARGET=northstar TYPE=z80 $(LIBLINKER) -DFORnorthstar -x$(OUTPUT_DIRECTORY)/northstar @$(TARGET_DIRECTORY)/northstar/northstar.lst

# TIKI-100 library - Stefano
tiki100.lib: cpm_clib.lib classic/games/obj/.stamp-cpm-tiki100 classic/gfx/obj/.stamp-cpm-tiki100
	@echo ''
	@echo '--- Building TIKI-100 Library ---'
	@echo ''
	TARGET=tiki100 TYPE=z80 $(LIBLINKER) -DFORtiki100 -x$(OUTPUT_DIRECTORY)/tiki100 @$(TARGET_DIRECTORY)/tiki100/tiki100.lst

# RCM2/3000 lib
rcmx000_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-rcmx000
	@echo ''
	@echo '--- Building RCM2/3000 Library ---'
	@echo ''
	TARGET=rcmx000 TYPE=r2ka $(LIBLINKER) -mr2ka -DSTANDARDESCAPECHARS -DFORrcmx000 -x$(OUTPUT_DIRECTORY)/rcmx000_clib @$(TARGET_DIRECTORY)/rcmx000/rcmx000.lst

# embedded target - contributed by Daniel Wallner
embedded_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-embedded
	@echo ''
	@echo '--- Building Embedded (ns16450) Library ---'
	@echo ''
	TARGET=embedded TYPE=z80 $(LIBLINKER) -DFORembedded -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/embedded_clib @$(TARGET_DIRECTORY)/embedded/embedded.lst

# Galaksija - Stefano Bodrato
gal_clib.lib: $(TARGET_CLIB_DEPS) $(GAL_TARGETS)
	@echo ''
	@echo '--- Building Galaksija Library ---'
	@echo ''
	TARGET=gal TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORgal -x$(OUTPUT_DIRECTORY)/gal_clib @$(TARGET_DIRECTORY)/gal/gal.lst

# Sharp PC-G8xx/E2xx - Stefano Bodrato
e200_clib.lib:  $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=e200 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/e200_clib @$(TARGET_DIRECTORY)/g800/g800.lst
	@touch $@

g815_clib.lib:  $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=g815 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g815_clib @$(TARGET_DIRECTORY)/g800/g815.lst
	@touch $@

g815b.lib:  g815_clib.lib $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=g815 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g815b @$(TARGET_DIRECTORY)/g800/g800.lst
	@touch $@

g850_clib.lib:  $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=g850 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g850_clib @$(TARGET_DIRECTORY)/g800/g850.lst
	@touch $@

g850b.lib:  g850_clib.lib $(TARGET_CLIB_DEPS) $(G800_TARGETS)
	TARGET=g850 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORg800 -x$(OUTPUT_DIRECTORY)/g850b @$(TARGET_DIRECTORY)/g800/g850b.lst
	@touch $@
# Camputers Lynx - Stefano Bodrato
lynx_clib.lib: $(TARGET_CLIB_DEPS) $(LYNX_TARGETS)
	@echo ''
	@echo '--- Building Camputers Lynx Library ---'
	@echo ''
	$(MAKE) -C classic/video/mc6845 TARGET=lynx
	TARGET=lynx TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORlynx -x$(OUTPUT_DIRECTORY)/lynx_clib @$(TARGET_DIRECTORY)/lynx/lynx.lst

# Sega Master system - contributed by Haroldo O. Pinheiro
sms_clib.lib: $(TARGET_CLIB_DEPS) $(SMS_TARGETS)
	@echo ''
	@echo '--- Building Sega Master System Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=sms
	TARGET=sms TYPE=z80 $(LIBLINKER) -DFORsms -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sms_clib @$(TARGET_DIRECTORY)/sms/sms.lst

# Sega SC-3000 - stefano
sc3000_clib.lib: $(TARGET_CLIB_DEPS) $(SC3000_TARGETS)
	@echo ''
	@echo '--- Building SC-3000 System Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=sc3000
	TARGET=sc3000 TYPE=z80 $(LIBLINKER) -DFORsc3000 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sc3000_clib @$(TARGET_DIRECTORY)/sc3000/sc3000.lst

# Gameboy - dom
gb_clib.lib: $(TARGET_CLIB_DEPS) $(GB_TARGETS)
	@echo ''
	@echo '--- Building Gameboy Library ---'
	@echo ''
	TARGET=gb TYPE=gbz80 $(LIBLINKER) -mgbz80 -DFORgb -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gb_clib @$(TARGET_DIRECTORY)/gb/gb.lst


# Test platform - dom
test_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-test
	@echo ''
	@echo '--- Building Test System Library ---'
	@echo ''
	TARGET=test TYPE=z80 $(LIBLINKER2) -mz80 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test_clib @$(TARGET_DIRECTORY)/test/test.lst

testz180_clib.lib: $(TARGET_CLIB_DEPS) test_clib.lib
	@echo ''
	@echo '--- Building Test System Library (z180) ---'
	@echo ''
	TARGET=test TYPE=z180 $(LIBLINKER2) -mz180 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testz180_clib @$(TARGET_DIRECTORY)/test/test.lst

testez80_z80_clib.lib: $(TARGET_CLIB_DEPS) testz180_clib.lib
	@echo ''
	@echo '--- Building Test System Library (ez80_z80) ---'
	@echo ''
	TARGET=test TYPE=ez80_z80 $(LIBLINKER2) -mez80_z80 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testez80_z80_clib @$(TARGET_DIRECTORY)/test/test.lst

testrcm_clib.lib: $(TARGET_CLIB_DEPS) testez80_z80_clib.lib
	@echo ''
	@echo '--- Building Test System Library (Rabbit) ---'
	@echo ''
	TARGET=test TYPE=r2ka $(LIBLINKER2) -mr2ka -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testrcm_clib @$(TARGET_DIRECTORY)/test/testrcm.lst

testrcm4k_clib.lib: $(TARGET_CLIB_DEPS) testrcm_clib.lib
	@echo ''
	@echo '--- Building Test System Library (Rabbit4k) ---'
	@echo ''
	TARGET=test TYPE=r4k $(LIBLINKER2) -mr4k -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testrcm4k_clib @$(TARGET_DIRECTORY)/test/testrcm.lst

test8080_clib.lib: $(TARGET_CLIB_DEPS) testrcm4k_clib.lib
	@echo ''
	@echo '--- Building Test System Library (8080) ---'
	@echo ''
	TARGET=test TYPE=8080 $(LIBLINKER2) -m8080 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test8080_clib @$(TARGET_DIRECTORY)/test/test8080.lst

test8085_clib.lib: $(TARGET_CLIB_DEPS) test8080_clib.lib
	@echo ''
	@echo '--- Building Test System Library (8085) ---'
	@echo ''
	TARGET=test TYPE=8085 $(LIBLINKER2) -m8085 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test8085_clib @$(TARGET_DIRECTORY)/test/test8085.lst

testvm1_clib.lib: $(TARGET_CLIB_DEPS) test8085_clib.lib
	@echo ''
	@echo '--- Building Test System Library (vm1) ---'
	@echo ''
	TARGET=test TYPE=vm1 $(LIBLINKER2) -mvm1 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testvm1_clib @$(TARGET_DIRECTORY)/test/testvm1.lst

testgbz80_clib.lib: $(TARGET_CLIB_DEPS) testvm1_clib.lib
	@echo ''
	@echo '--- Building Test System Library (gbz80) ---'
	@echo ''
	TARGET=test TYPE=gbz80 $(LIBLINKER2) -mgbz80 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testgbz80_clib @$(TARGET_DIRECTORY)/test/testgbz80.lst

testkc160_clib.lib: $(TARGET_CLIB_DEPS) testgbz80_clib.lib
	@echo ''
	@echo '--- Building Test System Library (kc160) ---'
	@echo ''
	TARGET=test TYPE=kc160 $(LIBLINKER2) -mkc160 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testkc160_clib @$(TARGET_DIRECTORY)/test/test.lst


# TRS 80 - stefano
trs80_clib.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS)
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORtrs80 -x$(OUTPUT_DIRECTORY)/trs80_clib @$(TARGET_DIRECTORY)/trs80/trs80.lst
	@touch $@

trs80_cpm.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS)
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/trs80_cpm @$(TARGET_DIRECTORY)/trs80/trs80_cpm.lst
	@touch $@

gfxtrs80.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS)
	TARGET=trs80 TYPE=z80 $(LIBLINKER) -DFORtrs80 -x$(OUTPUT_DIRECTORY)/gfxtrs80 @$(TARGET_DIRECTORY)/trs80/gfxtrs80.lst
	@touch $@

gfxtrs80m2.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS) $(TRS80M2_MC6845_OBJECTS) classic/gfx/obj/.stamp-trs80m2
	TARGET=trs80m2 TYPE=z80 $(LIBLINKER) -DFORtrs80m2 -x$(OUTPUT_DIRECTORY)/gfxtrs80m2 @$(TARGET_DIRECTORY)/trs80/gfxtrs80m2.lst
	@touch $@

gfxtrs80m4.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS) classic/gfx/obj/.stamp-trs80m4
	TARGET=trs80m4 TYPE=z80 $(LIBLINKER) -DFORtrs80m4 -x$(OUTPUT_DIRECTORY)/gfxtrs80m4 @$(TARGET_DIRECTORY)/trs80/gfxtrs80m4.lst
	@touch $@

gfxeg2000.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS) classic/gfx/obj/.stamp-eg2000
	TARGET=eg2000 TYPE=z80 $(LIBLINKER) -DFOReg2000 -x$(OUTPUT_DIRECTORY)/gfxeg2000 @$(TARGET_DIRECTORY)/trs80/gfxeg2000.lst
	@touch $@

gfxhrg1.lib:  $(TARGET_CLIB_DEPS) $(TRS80_TARGETS) classic/gfx/obj/.stamp-hrg1
	TARGET=hrg1 TYPE=z80 $(LIBLINKER) -DFORhrg1 -x$(OUTPUT_DIRECTORY)/gfxhrg1 @$(TARGET_DIRECTORY)/trs80/gfxhrg1.lst
	@touch $@

grafyx4_3.lib:  $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-trs80 classic/gfx/obj/.stamp-trs80-base classic/gfx/obj/.stamp-grafyx3
	TARGET=grafyx3 TYPE=z80 $(LIBLINKER) -DFORgrafyx3 -x$(OUTPUT_DIRECTORY)/grafyx4_3 @$(TARGET_DIRECTORY)/trs80/grafyx.lst
	@touch $@

grafyx4.lib:  $(TARGET_CLIB_DEPS) classic/games/obj/.stamp-trs80 classic/gfx/obj/.stamp-trs80-base classic/gfx/obj/.stamp-grafyx4
	TARGET=grafyx4 TYPE=z80 $(LIBLINKER) -DFORgrafyx4 -x$(OUTPUT_DIRECTORY)/grafyx4 @$(TARGET_DIRECTORY)/trs80/grafyx.lst
	@touch $@
# Canon X-07 lib - Stefano
# Machine use alt registers for interrupts, so we have to use 8080 routines
# But, we can use z80 instructinos
x07_clib.lib: $(TARGET_CLIB_DEPS) $(X07_TARGETS)
	@echo ''
	@echo '--- Building Canon X-07 Library ---'
	@echo ''
	TARGET=x07 TYPE=z80 $(LIBLINKER) -mz80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/x07_clib @$(TARGET_DIRECTORY)/x07/x07.lst

# Sharp X1 (ANSI VT) - Karl Von Dyson (X1s.org)
x1_clib.lib: $(TARGET_CLIB_DEPS) $(X1_TARGETS)
	@echo ''
	@echo '--- Building Sharp X1 Library ---'
	@echo ''
	TARGET=x1 TYPE=z80 $(LIBLINKER) -DFORx1 -x$(OUTPUT_DIRECTORY)/x1_clib @$(TARGET_DIRECTORY)/x1/x1.lst

# Philips VG5000 lib - Joaopa, Stefano
vg5k_clib.lib: $(TARGET_CLIB_DEPS) $(VG5K_TARGETS)
	@echo ''
	@echo '--- Building Philips VG5000 Library ---'
	@echo ''
	TARGET=vg5k TYPE=ixiy $(LIBLINKER) -IXIY -DFORvg5k -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/vg5k_clib @$(TARGET_DIRECTORY)/vg5k/vg5k.lst

# S-OS (The Sentinel) - Stefano
sos_clib.lib: $(TARGET_CLIB_DEPS) $(SOS_TARGETS)
	@echo ''
	@echo '--- Building S-OS (The Sentinel) Library ---'
	@echo ''
	TARGET=sos TYPE=z80 $(LIBLINKER) -DFORsos -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sos_clib.lib @$(TARGET_DIRECTORY)/sos/sos.lst

# OSCA / FLOS - Stefano
osca_clib.lib: $(TARGET_CLIB_DEPS) $(SDCARD_OBJS) $(OSCA_TARGETS)
	@echo ''
	@echo '--- Building Old School Computer Architecture Library ---'
	@echo ''
	TARGET=osca TYPE=z80 $(LIBLINKER) -DFORosca -DSTANDARDESCAPECHARS -DSDHC_SUPPORT -x$(OUTPUT_DIRECTORY)/osca_clib.lib @$(TARGET_DIRECTORY)/osca/osca.lst

# s1mp3
s1mp3_clib.lib: $(TARGET_CLIB_DEPS) $(S1MP3_TARGETS)
	@echo ''
	@echo '--- Building s1mp3 Library ---'
	@echo ''
	TARGET=s1mp3 TYPE=z80 $(LIBLINKER) -DFORs1mp3 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/s1mp3_clib.lib @$(TARGET_DIRECTORY)/s1mp3/s1mp3.lst

pmd85_clib.lib: $(TARGET_CLIB_DEPS) $(PMD85_TARGETS)
	@echo ''
	@echo '--- Building pmd85 Library ---'
	@echo ''
	TARGET=pmd85 TYPE=8080 $(LIBLINKER) -m8080 -DFORpmd85 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pmd85_clib @$(TARGET_DIRECTORY)/pmd85/pmd85.lst

mikro80_clib.lib: $(TARGET_CLIB_DEPS) $(MIKRO80_TARGETS)
	@echo ''
	@echo '--- Building Mikro80 Library ---'
	@echo ''
	TARGET=mikro80 TYPE=8080 $(LIBLINKER) -m8080 -DFORmikro80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/mikro80_clib @$(TARGET_DIRECTORY)/mikro80/mikro80.lst

special_clib.lib: $(TARGET_CLIB_DEPS) $(SPECIAL_TARGETS)
	@echo ''
	@echo '--- Building Specialist Library ---'
	@echo ''
	TARGET=special TYPE=8080 $(LIBLINKER) -m8080 -DFORspecial -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/special_clib.lib @$(TARGET_DIRECTORY)/special/special.lst

m100_clib.lib: $(TARGET_CLIB_DEPS) $(M100_TARGETS)
	@echo ''
	@echo '--- Building m100 Library ---'
	@echo ''
	TARGET=m100 TYPE=8085 $(LIBLINKER) -m8085 -DFORm100 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/m100_clib @$(TARGET_DIRECTORY)/m100/m100.lst

vector06c_clib.lib: $(TARGET_CLIB_DEPS) $(VECTOR06C_TARGETS)
	@echo ''
	@echo '--- Building Vector06c Library ---'
	@echo ''
	TARGET=vector06c TYPE=8080 $(LIBLINKER) -m8080 -DFORvector06c -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/vector06c_clib @$(TARGET_DIRECTORY)/vector06c/vector06c.lst

pk8000_clib.lib: $(TARGET_CLIB_DEPS) $(PK8000_TARGETS)
	@echo ''
	@echo '--- Building PK8000 Library ---'
	@echo ''
	#$(MAKE) -C classic/gfx TARGET=vector06c FLAVOUR=wide
	#$(MAKE) -C classic/games TARGET=vector06c
	TARGET=pk8000 TYPE=8080 $(LIBLINKER) -m8080 -DFORpk8000 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/pk8000_clib @$(TARGET_DIRECTORY)/pk8000/pk8000.lst

lviv_clib.lib: $(TARGET_CLIB_DEPS) $(LVIV_TARGETS)
	@echo ''
	@echo '--- Building PK-01 Lviv/Lvov Library ---'
	@echo ''
	TARGET=lviv TYPE=8080 $(LIBLINKER) -m8080 -DFORlviv -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/lviv_clib @$(TARGET_DIRECTORY)/lviv/lviv.lst

altair8800_clib.lib: $(TARGET_CLIB_DEPS) $(ALTAIR8800_TARGETS)
	@echo ''
	@echo '--- Building Altair8800 Library ---'
	@echo ''
	TARGET=altair8800 TYPE=8080 $(LIBLINKER) -m8080 -DFORaltair8800 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/altair8800_clib @$(TARGET_DIRECTORY)/altair8800/altair8800.lst

sol20_clib.lib: $(TARGET_CLIB_DEPS) $(SOL20_TARGETS)
	@echo ''
	@echo '--- Building SOL20 Library ---'
	@echo ''
	TARGET=sol20 TYPE=8080 $(LIBLINKER) -m8080 -DFORsol20 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/sol20_clib @$(TARGET_DIRECTORY)/sol20/sol20.lst

agon_clib.lib: $(TARGET_CLIB_DEPS) $(AGON_TARGETS)
	@echo ''
	@echo '--- Building Agon Light Library ---'
	@echo ''
	TARGET=agon TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -DFORagon -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/agon_clib @$(TARGET_DIRECTORY)/agon/agon.lst

dai_clib.lib: $(TARGET_CLIB_DEPS) $(DAI_TARGETS)
	@echo ''
	@echo '--- Building DAI Library ---'
	@echo ''
	TARGET=dai TYPE=8080 $(LIBLINKER) -m8080 -DFORdai -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/dai_clib @$(TARGET_DIRECTORY)/dai/dai.lst

ondra_clib.lib: $(TARGET_CLIB_DEPS) $(ONDRA_TARGETS)
	@echo ''
	@echo '--- Building Ondra Library ---'
	@echo ''
	TARGET=ondra TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORondra -x$(OUTPUT_DIRECTORY)/ondra_clib @$(TARGET_DIRECTORY)/ondra/ondra.lst

# Homelab 3/4 - dom
homelab_clib.lib: $(TARGET_CLIB_DEPS) $(HOMELAB_TARGETS)
	@echo ''
	@echo '--- Building Homelab Library ---'
	@echo ''
	TARGET=homelab TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhomelab -x$(OUTPUT_DIRECTORY)/homelab_clib @$(TARGET_DIRECTORY)/homelab/homelab.lst

# Homelab2  - dom
homelab2_clib.lib: $(TARGET_CLIB_DEPS) $(HOMELAB2_TARGETS)
	@echo ''
	@echo '--- Building Homelab2 Library ---'
	@echo ''
	TARGET=homelab2 TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORhomelab2 -x$(OUTPUT_DIRECTORY)/homelab2_clib @$(TARGET_DIRECTORY)/homelab2/homelab2.lst

krokha_clib.lib: $(TARGET_CLIB_DEPS) $(KROKHA_TARGETS)
	@echo ''
	@echo '--- Building Krokha (tiny) Library ---'
	@echo ''
	TARGET=krokha TYPE=8080 $(LIBLINKER) -m8080 -DFORkrokha -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/krokha_clib @$(TARGET_DIRECTORY)/krokha/krokha.lst

radio86_clib.lib: $(TARGET_CLIB_DEPS) $(RADIO86_TARGETS)
	@echo ''
	@echo '--- Building Radio86 Library ---'
	@echo ''
	TARGET=radio86 TYPE=8080 $(LIBLINKER) -m8080 -DFORradio86 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/radio86_clib @$(TARGET_DIRECTORY)/radio86/radio86.lst

# RC2014 (newlib target) using 8085 CPU Module - feilipu
rc2014-8085_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-rc2014
	@echo ''
	@echo '--- Building RC2014-8085 Library ---'
	@echo ''
	m4 -DCFG_ASM_DEF target/rc2014/config_8085.m4 > target/rc2014/config_rc2014-8085_private.inc
	m4 -DCFG_ASM_PUB target/rc2014/config_8085.m4 > target/rc2014/config_rc2014-8085_public.inc
	m4 -DCFG_C_DEF target/rc2014/config_8085.m4 > target/rc2014/config_rc2014-8085.h
	$(RM) target/rc2014/driver/ide/asm/*.o
	$(RM) target/rc2014/driver/diskio/8085/*.o
	TARGET=rc2014 TYPE=8085 $(LIBLINKER) -m8085 -DFORrc2014 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/rc2014-8085_clib @$(TARGET_DIRECTORY)/rc2014/rc2014-8085.lst

gfxvti.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-vti
	@echo ''
	@echo '--- Building VTI graphics Library ---'
	@echo ''
	TARGET=vti TYPE=8080 $(LIBLINKER) -m8080 -DFORvti -x$(OUTPUT_DIRECTORY)/gfxvti @$(Z88DK_LIBSRC)/classic/video/vti/video_vti.lst

gfxtek.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-tek
	@echo ''
	@echo '--- Building TEK4010 graphics Library ---'
	@echo ''
	$(MAKE) -C classic/video/tek401x TARGET=test 
	TARGET=tek TYPE=z80 $(LIBLINKER) -mz80 -DFORtek -x$(OUTPUT_DIRECTORY)/gfxtek @$(Z88DK_LIBSRC)/classic/video/tek401x/video_tek.lst

gfxregis.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-regis
	@echo ''
	@echo '--- Building ReGIS graphics Library ---'
	@echo ''
	$(MAKE) -C classic/video/regis TARGET=test 
	TARGET=regis TYPE=z80 $(LIBLINKER) -mz80 -DFORregis -x$(OUTPUT_DIRECTORY)/gfxregis @$(Z88DK_LIBSRC)/classic/video/regis/video_regis.lst

gfxh19.lib:  $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-h19 classic/gfx/obj/.stamp-h19alt
	TARGET=h19 TYPE=z80 $(LIBLINKER) -DFORh19 -x$(OUTPUT_DIRECTORY)/gfxh19 @$(Z88DK_LIBSRC)/classic/video/h19/gfxh19.lst
	@touch $@

gfxh19alt.lib:  $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-h19 classic/gfx/obj/.stamp-h19alt
	TARGET=h19alt TYPE=z80 $(LIBLINKER) -DFORh19alt -x$(OUTPUT_DIRECTORY)/gfxh19alt @$(Z88DK_LIBSRC)/classic/video/h19/gfxh19alt.lst
	@touch $@

gfxvio.lib:  $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-vio
	TARGET=vio TYPE=8080 $(LIBLINKER) -m8080 -DFORvio -x$(OUTPUT_DIRECTORY)/gfxvio @$(Z88DK_LIBSRC)/classic/video/vio/video_vio.lst
	@touch $@

gfxvdm.lib:  $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-vdm
	TARGET=vdm TYPE=8080 $(LIBLINKER) -m8080 -DFORvdm -x$(OUTPUT_DIRECTORY)/gfxvdm @$(Z88DK_LIBSRC)/classic/video/vdm/video_vdm.lst
	@touch $@

nanos.lib:  $(TARGET_CLIB_DEPS) $(NANOS_TARGETS) classic/gfx/obj/.stamp-h19 classic/gfx/obj/.stamp-h19alt
	TARGET=nanos TYPE=z80 $(LIBLINKER) -mz80 -DFORnanos -x$(OUTPUT_DIRECTORY)/nanos @$(Z88DK_LIBSRC)/target/nanos/nanos.lst
	@touch $@
# Preempt multitasking library - dom
preempt.lib:
	@echo ''
	@echo '--- Building Preemptive threading Library ---'
	@echo ''
	$(MAKE) -C classic/threading/preempt

# SP1 sprite library - aralbrec
sp1-all:
	$(MAKE) -C sprites/software/sp1  sp1-all

sp1-clean:
	$(MAKE) -C sprites/software/sp1 clean

# The crt0 rules live in classic/z80_crt0s/z80_crt0s.mak, included with the
# other .mak files above. It defines CRT0_STAMP, and its generated
# obj/<cpu>-crt0.d files supply the per-source prerequisites that decide when
# a crt0 library needs relinking.

z80_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,z80)
	@echo ''
	@echo '--- Building z80 crt Library ---'
	@echo ''
	TYPE=z80 $(LIBLINKER) -mz80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z80_crt0 @$(LISTFILE_DIRECTORY)/z80.lst

ez80_z80_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,ez80_z80)
	@echo ''
	@echo '--- Building ez80_z80 crt Library ---'
	@echo ''
	TYPE=ez80_z80 $(LIBLINKER) -mez80_z80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/ez80_z80_crt0 @$(LISTFILE_DIRECTORY)/ez80_z80.lst

z180_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,z180)
	@echo ''
	@echo '--- Building z180 crt Library ---'
	@echo ''
	TYPE=z180 $(LIBLINKER) -mz180 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z180_crt0 @$(LISTFILE_DIRECTORY)/z180.lst

z80iy_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,ixiy)
	@echo ''
	@echo '--- Building ixiy crt Library ---'
	@echo ''
	TYPE=ixiy $(LIBLINKER) -mz80 -IXIY -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z80iy_crt0 @$(LISTFILE_DIRECTORY)/z80.lst

8080_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,8080)
	@echo ''
	@echo '--- Building 8080 crt Library ---'
	@echo ''
	TYPE=8080 $(LIBLINKER) -m8080 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/8080_crt0 @$(LISTFILE_DIRECTORY)/8080.lst

8085_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,8085)
	@echo ''
	@echo '--- Building 8085 crt Library ---'
	@echo ''
	TYPE=8085 $(LIBLINKER) -m8085 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/8085_crt0 @$(LISTFILE_DIRECTORY)/8085.lst

vm1_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,vm1)
	@echo ''
	@echo '--- Building vm1 crt Library ---'
	@echo ''
	TYPE=vm1 $(LIBLINKER) -mvm1 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/vm1_crt0 @$(LISTFILE_DIRECTORY)/vm1.lst

z80n_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,z80n)
	@echo ''
	@echo '--- Building z80n crt Library ---'
	@echo ''
	TYPE=z80n $(LIBLINKER) -mz80n -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/z80n_crt0 @$(LISTFILE_DIRECTORY)/z80.lst

gbz80_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,gbz80)
	@echo ''
	@echo '--- Building gbz80 crt Library ---'
	@echo ''
	TYPE=gbz80 $(LIBLINKER) -mgbz80 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/gbz80_crt0 @$(LISTFILE_DIRECTORY)/gbz80.lst

r2ka_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,r2ka)
	@echo ''
	@echo '--- Building r2ka crt Library ---'
	@echo ''
	TYPE=r2ka $(LIBLINKER) -mr2ka -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/r2ka_crt0 @$(LISTFILE_DIRECTORY)/rabbit.lst

r4k_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,r4k)
	@echo ''
	@echo '--- Building r4k crt Library ---'
	@echo ''
	TYPE=r4k $(LIBLINKER) -mr4k -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/r4k_crt0 @$(LISTFILE_DIRECTORY)/rabbit.lst

kc160_crt0.lib: $(DIRS) $(OBJS) $(call CRT0_STAMP,kc160)
	@echo ''
	@echo '--- Building kc160 crt Library ---'
	@echo ''
	TYPE=kc160 $(LIBLINKER) -mkc160 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/kc160_crt0 @$(LISTFILE_DIRECTORY)/z80.lst


install:
	cp $(OUTPUT_DIRECTORY)/*.lib ../lib/clibs

clean: classic-clean new-clean

install-clean: classic-clean new-install-clean

classic-clean: $(CLEAN)
	$(MAKE) -C classic/fcntl clean
	$(MAKE) -C math clean
	$(MAKE) -C classic/threading/preempt clean
	$(MAKE) -C sprites/software/sp1 clean
	$(MAKE) -C classic/games clean
	$(MAKE) -C target clean
	$(MAKE) -C classic/video clean
	$(MAKE) -C classic/gfx clean
	$(RM) *.lib

new-clean:
	$(MAKE) -C newlib clean

new-install-clean:
	$(MAKE) -C newlib install-clean
