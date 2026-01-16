

all: binaries 

include ../../support/multitarget_build/Makefile

# Hello world 
FEATURE_TARGETS = abc80 abc800 ace adam agon alphatp2 alphatro altair8800 aquarius aquarius_rom aqplus bee c128 c7420 coleco bit90 cpc cpm dai \
	eg2000 enterprise excali64 fp1100 g800 gal galplus gamegear gb gl gl4000 gl6000  \
	hector hectorhr \
	hemc hgmc homelab homelab2 kc kramermc krokha lambda laser500 lm80c lviv lynx m5 m100 m100_optrom m10 m10_optrom kc85 kc85_optrom pc8201 \
	map1010 mc1000 micro8085 mikro80 \
	msx msx_msxdos1 msx_msxdos2 msx_rom msx2_rom mtx multi8 myvision mz mz2500 nabu nascom nc nc200 newbrain ondra osca oz p2000 pacman pasopia7 pc6001 pc6001_rom pc88 pc88_disk \
	pencil2 phc25 pmd85 pps primo pv1000  \
	pv2000 rcmx000 rx78 sam sam_allram sam_highram sc3000 sc3000_rom s1mp3 smc777 sms sol20 sos spc1000 special srr super80 super80_vduem svi svi_rom svi_rom318 svi_disk test ti82 ti83 ti85 ti86 ti83p \
	trs80 ts2068 tvc vector06c vector06c_disk vg5k vz x07 x1 z1013 z9001 z88 z88_app zx zx_rom zx80 zx81 zxn zxn_dot

FEATURE_TARGETS += $(patsubst %,cpm_%, $(CPMSUBTYPES))

CFLAGS += -pragma-define:CRT_HEAP_AMALLOC=1

LDFLAGS_ace_feature = -lgfxace
LDFLAGS_c128_feature = -lgfx128
LDFLAGS_cpc_feature = -lcpcfs
LDFLAGS_eg2000_feature = -lndos
LDFLAGS_enterprise_feature = -lgfxephr
LDFLAGS_nc_feature = -lgfxnc100
LDFLAGS_newbrain_feature = -lnbdrv
LDFLAGS_osca_feature = -lflosdos
LDFLAGS_zx_feature = -lp3
LDFLAGS_zxn_feature = -lesxdos

# Just need a graphics library for CP/M on TRS80
LDFLAGS_cpm_ptcpm_feature = -lgfxtrs80
LDFLAGS_cpm_fmgcpm_feature = -lgfxtrs80
LDFLAGS_cpm_holmes_feature = -lgfxtrs80
LDFLAGS_cpm_lifeboat_feature = -lgfxtrs80
LDFLAGS_cpm_lnw80_feature = -lgfxtrs80
LDFLAGS_cpm_max80_feature = -lgfxtrs80
LDFLAGS_cpm_merchant_feature = -lgfxtrs80
LDFLAGS_cpm_montezuma_feature = -lgfxtrs80
LDFLAGS_cpm_m4cpm3_feature = -lgfxtrs80



OUTPUT_BINS += $(foreach target, $(FEATURE_TARGETS),  build/$(target)/feature.bin )
$(eval $(call build_app, $(FEATURE_TARGETS), feature.bin, feature.c) )


binaries: $(OUTPUT_BINS)

