# Ah, that'd be nice, a library makefile!
#
# Problems? Contact the person to blame(!) above the section
# for the library
#
# $Id: Makefile $


include Make.config

.DEFAULT_GOAL := all

TARGETS ?= all

TOCREATE =

# $1 = target
# $2 = libs
check_target = $(if $(or $(filter $(1),$(TARGETS)), $(filter all,$(TARGETS))),$(2),)

# Recursive wildcard expansion for portable source discovery.
rwildcard = $(foreach entry,$(wildcard $(1)/*),$(call rwildcard,$(entry),$(2)) $(filter $(subst *,%,$(2)),$(entry)))

GENLIBS = z80_crt0.lib z80iy_crt0.lib z80n_crt0.lib z180_crt0.lib 8080_crt0.lib 8085_crt0.lib vm1_crt0.lib gbz80_crt0.lib r2ka_crt0.lib r4k_crt0.lib ez80_z80_crt0.lib kc160_crt0.lib math48.lib genmath.lib mbf32.lib mbf64.lib math16.lib math32.lib daimath32.lib am9511.lib gendos.lib ndos.lib fastmath.lib preempt.lib sp1-all
GENLIBS += gfxtek.lib gfxregis.lib



OBJS = 
DIRS =
CLEAN = 

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
include classic/video/video.mak
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

# Targets depend on some common code + target specific (include stdio in here)
TARGET_CLIB_DEPS = $(STDIO_OBJS) $(X11_OBJS) $(GFXPORTABLE_OBJS) $(RETROFIT_OBJS) $(GAMES_NEWLIB_TARGETS) $(INPUT_OBJS) $(SOUND_SAA1099_TARGETS) $(SOUND_AY_TARGETS) $(SOUND_SN76489_TARGETS) $(TIME_TARGETS)

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

all: $(GENLIBS) $(TOCREATE)

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

classic-clean: $(CLEAN) classic-games-clean classic-video-clean classic-gfx-clean
	$(MAKE) -C classic/fcntl clean
	$(MAKE) -C math clean
	$(MAKE) -C classic/threading/preempt clean
	$(MAKE) -C sprites/software/sp1 clean
	$(RM) *.lib

classic-games-clean:
	$(RM) -fr classic/games/obj
	$(RM) classic/games/*.o classic/games/*/*.o

classic-video-clean:
	$(RM) -fr classic/video/*/obj
	$(RM) classic/video/*/*.o classic/video/*/*/*.o

classic-gfx-clean:
	$(RM) -fr classic/gfx/obj classic/gfx/*/obj
	$(RM) classic/gfx/*/*.o classic/gfx/*/*/*.o

.PHONY: classic-games-clean classic-video-clean classic-gfx-clean

new-clean:
	$(MAKE) -C newlib clean

new-install-clean:
	$(MAKE) -C newlib install-clean
