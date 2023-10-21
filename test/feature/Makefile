

all: binaries 

include ../../support/multitarget_build/Makefile

# Hello world 
FEATURE_TARGETS = abc80 abc800 ace adam agon alphatro altair8800 aquarius aquarius_rom aqplus bee c128 c7420 coleco bit90 cpc cpm dai \
	eg2000 enterprise excali64 fp1100 g800 gal galplus gamegear gb gl gl4000 gl6000  \
	hemc hgmc homelab homelab2 kc kramermc krokha lambda laser500 lm80c lviv lynx m5 m100 m100_optrom mc1000 micro8085 mikro80 \
	msx msx_msxdos1 msx_msxdos2 msx_rom msx2_rom mtx multi8 myvision mz mz2500 nabu nascom nc newbrain ondra osca oz p2000 pacman pasopia7 pc6001 pc6001_rom pc88 pc88_disk \
	pencil2 pmd85 pps primo pv1000  \
	pv2000 rcmx000 rx78 sam sam_allram sam_highram sc3000 sc3000_rom s1mp3 smc777 sms sol20 sos spc1000 special srr super80 super80_vduem svi svi_rom svi_rom318 svi_disk test ti82 ti83 ti85 ti86 ti83p \
	trs80 ts2068 tvc vector06c vector06c_disk vg5k vz x07 x1 z1013 z9001 z88 z88_app zx zx_rom zx80 zx81 zxn zxn_dot

FEATURE_TARGETS += cpm_px8 cpm_px4 cpm_einstein cpm_einstein256 cpm_attache cpm_osborne1 cpm_kaypro83 cpm_kaypro84 \
	cpm_mz2500 cpm_microbee cpm_qc10 cpm_nascom cpm_tiki100 cpm_svi cpm_dmv cpm_adam \
	cpm_smc777 cpm_rc700 cpm_fp1100 cpm_x1 cpm_lynx cpm_bic cpm_excali64 cpm_vector06c \
	cpm_zxplus3 cpm_bondwell cpm_bondwell2 cpm_8080 cpm_aussie cpm_cpc cpm_pcw40 cpm_pcw80 cpm_nabu cpm_corvette \
	cpm_mbc200 cpm_mbc1100 cpm_mbc1160 cpm_mbc2000 cpm_x820 cpm_partner cpm_v1050 \
	cpm_tim011 cpm_hz89 cpm_hz100 

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



OUTPUT_BINS += $(foreach target, $(FEATURE_TARGETS),  build/$(target)/feature.bin )
$(eval $(call build_app, $(FEATURE_TARGETS), feature.bin, feature.c) )


binaries: $(OUTPUT_BINS)

