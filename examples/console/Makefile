

all: binaries 

include ../../support/multitarget_build/Makefile

# Hello world 
WORLD_TARGETS = abc80 abc800 ace adam alphatro altair8800 aquarius aqplus bee c128 c7420 coleco bit90 cpc cpm dai \
	eg2000 enterprise fp1100 g800 gal gamegear gl  gl4000 gl6000  \
	hemc hgmc homelab homelab2 kc kramermc lambda laser500 lviv lynx m5 m100 mc1000 micro8085 mikro80 \
	msx msx2_rom mtx multi8 myvision mz mz2500 nascom nc newbrain ondra osca oz p2000 pacman pasopia7 pc6001 \
	pencil2 pps primo pv1000  \
	pv2000 rcmx000 rx78 sam sc3000 smc777 sms sol20 sos spc1000 special srr super80 super80_vduem svi svi_rom svi_rom318 test ti82 ti83 ti85 ti86 ti83p \
	trs80 ts2068 vector06c vector06c_disk vg5k vz x07 x1 z1013 z9001 z88 zx zx80 zx81 zxn

WORLD_TARGETS += cpm_px8 cpm_px4 cpm_einstein cpm_einstein256 cpm_attache cpm_osborne1 cpm_kaypro83 cpm_kaypro84 \
	cpm_mz2500 cpm_microbee cpm_qc10 cpm_nascom cpm_tiki100 cpm_svi cpm_dmv cpm_adam \
	cpm_smc777 cpm_rc700 cpm_fp1100 cpm_x1 cpm_lynx cpm_bic cpm_excali64 cpm_vector06c \
	cpm_zxplus3 cpm_bondwell cpm_bondwell2 cpm_8080 cpm_corvette cpm_nabu cpm_x820 cpm_v1050

LDFLAGS_world = -lndos -pragma-define:CLIB_OPT_PRINTF=0x00000001


OUTPUT_BINS += $(foreach target, $(WORLD_TARGETS),  build/$(target)/world.bin )
$(eval $(call build_app, $(WORLD_TARGETS), world.bin, world.c) )

# Hello world using conio features

CONIO_TARGETS = abc80 ace adam alphatro aquarius aqplus bee cpc coleco cpm fp1100 gb hemc hgmc homelab homelab2 \
	kramermc laser500 mc1000 mikro80 nabu \
	nascom ondra pmd85 pv1000 pps rx78 sam spc1000 srr super80 super80_vduem trs80 vg5k vz z1013 zx80 zx81 \
	msx msx2_rom pv2000 sc3000 smc777 svi m5 mtx multi8 z80tvgame z9001 vector06c zx \
	cpm_einstein cpm_einstein256

CFLAGS_world_conio = --generic-console
CFLAGS_cpm_world_conio = -pragma-define:CONSOLE_ROWS=25 -pragma-define:CONSOLE_COLUMNS=80

OUTPUT_BINS += $(foreach target, $(CONIO_TARGETS),  build/$(target)/world_conio.bin )
$(eval $(call build_app, $(CONIO_TARGETS), world_conio.bin, world_conio.c) )

# Testing the vt100 library

ANSI_TARGETS = abc80 ace aquarius bee cpc gal mc1000 msx msx2_rom mtx mz nascom osca p2000 pc6001 \
	pps sam sc3000 svi ti82 ti83 ti85 ti86 ti83p ts2068 vz x1 z1013 z88 zx z9001 \
	cpm_einstein cpm_einstein256 

CFLAGS_ansitest = -clib=ansi

LDFLAGS_ansitest = -lndos

OUTPUT_BINS += $(foreach target, $(ANSI_TARGETS),  build/$(target)/ansitest.bin )
$(eval $(call build_app, $(ANSI_TARGETS), ansitest.bin, ansitest.c) )


## Dstar (Gencon edition)

DSTAR_TARGETS = zx sv8000 coleco laser500

CFLAGS_zx_dstar = -DUSE_UDGS
CFLAGS_laser500_dstar = -DUSE_UDGS -DSWITCH_MODE=2
CFLAGS_sv8000_dstar = -DUSE_JOYSTICK -DUSE_UDGS -DSWITCH_MODE=1 -pragma-redirect:CRT_FONT=_font_8x8_bbc_system
CFLAGS_coleco_dstar = -DUSE_JOYSTICK -DUSE_UDGS -DSWITCH_MODE=2

OUTPUT_BINS += $(foreach target, $(DSTAR_TARGETS),  build/$(target)/dstar.bin )
$(eval $(call build_app, $(DSTAR_TARGETS), dstar.bin, dstar_gencon.c) )

## Adventure A
ADVA_TARGETS = zx cpm msx
OUTPUT_BINS += $(foreach target, $(ADVA_TARGETS),  build/$(target)/adva.bin )
LDFLAGS_zx_adva = -lndos
CFLAGS_msx_adva = -subtype=rom

$(eval $(call build_app, $(ADVA_TARGETS), adva.bin, adv_a.c) )

binaries: $(OUTPUT_BINS)

clean:
	$(RM) -fr bin
