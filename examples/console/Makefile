

all: binaries 

include ../../support/multitarget_build/Makefile

WORLD_TARGETS = abc80 abc800 ace alphatro aquarius bee c128 c7420 coleco cpc cpm enterprise fp1100 \
	g800 gal hemc hgmc homelab kc kramermc lambda laser500 lynx m5 mc1000 mikro80 msx mtx \
	multi8 mz nascom nc newbrain osca oz p2000 pacman pasopia7 pc6001 pps primo pv1000  \
	pv2000 rcmx000 rx78 sam sc3000 sos spc1000 srr svi test ti82 ti83 ti85 ti86 ti8x \
	trs80 ts2068 vector06c vg5k vz x07 x1 z1013 z9001 z88 zx zx80 zx81

WORLD_TARGETS += cpm_px8 cpm_px4 cpm_einstein cpm_attache cpm_osborne1 cpm_kaypro83 cpm_kaypro84 \
	cpm_mz2500 cpm_microbee cpm_qc10 cpm_nascom cpm_tiki100 cpm_svi cpm_dmv cpm_adam \
	cpm_smc777 cpm_rc700 cpm_fp1100 cpm_x1 cpm_lynx cpm_bic cpm_excali64 cpm_vector06c \
	cpm_zxplus3

LDFLAGS_world = -lndos


OUTPUT_BINS += $(foreach target, $(WORLD_TARGETS),  build/$(target)/world.bin )
$(eval $(call build_app, $(WORLD_TARGETS), world.bin, world.c) )


CONIO_TARGETS = abc80 ace alphatro aquarius bee cpc coleco fp1100 hemc hgmc kramermc laser500 mc1000  \
	nascom pmd85 pv1000 pps rx78 spc1000 srr super80 trs80 vg5k vz z1013 zx80 zx81 msx pv2000 \
	sc3000 svi m5 mtx multi8 z80tvgame z9001 homelab vector06c zx

CFLAGS_world_conio = --generic-console

OUTPUT_BINS += $(foreach target, $(CONIO_TARGETS),  build/$(target)/world_conio.bin )
$(eval $(call build_app, $(CONIO_TARGETS), world_conio.bin, world_conio.c) )


ANSI_TARGETS = abc80 ace aquarius bee cpc gal mc1000 msx mtx mz nascom osca p2000 pc6001 \
	pps sam sc3000 svi ti82 ti83 ti85 ti86 ti8x ts2068 vz x1 z1013 z88 zx z9001

CFLAGS_ansitest = -clib=ansi

LDFLAGS_ansitest = -lndos

OUTPUT_BINS += $(foreach target, $(ANSI_TARGETS),  build/$(target)/ansitest.bin )
$(eval $(call build_app, $(ANSI_TARGETS), ansitest.bin, ansitest.c) )




binaries: $(OUTPUT_BINS)

