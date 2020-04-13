
TARGETS = abc80 abc800 ace alphatro aquarius bee c128 c7420 coleco cpc cpm enterprise fp1100 g800 gal hemc hgmc homelab kc kramermc lambda laser500 lynx m5 mc1000 msx mtx multi8 mz nascom nc newbrain osca oz p2000 pacman pasopia7 pc6001 pps pv1000 pv2000 rcmx000 rx78 sam sc3000 sos spc1000 srr svi test ti82 ti83 ti85 ti86 ti8x trs80 ts2068 vector06c vg5k vz x07 x1 z1013 z9001 z88 zx zx80 zx81 

TARGETCLASSIC = zxn

TARGETANSI = abc80 ace aquarius bee cpc gal mc1000 msx mtx mz nascom osca p2000 pc6001 pps sam sc3000 svi ti82 ti83 ti85 ti86 ti8x ts2068 vz x1 z1013 z88 zx z9001

TARGETGENERIC = abc80 ace alphatro aquarius bee cpc coleco fp1100 hemc hgmc kramermc laser500 mc1000 nascom pmd85 pv1000 pps rx78 spc1000 srr super80 trs80 vg5k vz z1013 zx80 zx81 msx pv2000 sc3000 svi m5 mtx multi8 z80tvgame z9001 homelab vector06c

CPMSUBTYPES = px8 px4 einstein attache osborne1 kaypro83 kaypro84 mz2500 microbee qc10 nascom tiki100 svi dmv adam smc777 rc700 fp1100 x1 lynx bic excali64 vector06c zxplus3

EXES = $(addprefix bin/,$(addsuffix /world, $(TARGETS))) $(addprefix bin/,$(addsuffix /ansitest, $(TARGETANSI))) $(addprefix bin/,$(addsuffix /world_conio, $(TARGETGENERIC))) $(addprefix bin/cpm/,$(addsuffix /world, $(CPMSUBTYPES))) $(addprefix bin/,$(addsuffix /world, $(TARGETCLASSIC)))

all: $(EXES)

define build_for
bin/$(1)/$(basename $(2)): $(2)
	@mkdir -p bin/$(1)
	zcc +$(1)  $(2) $(3) -o $$@ -lndos 
endef

define build_for_subtype
bin/cpm/$(4)/$(basename $(2)): $(2)
	@mkdir -p bin/cpm/$(4)
	zcc +$(1)  $(2) -subtype=$(4) $(3) -o $$@ -lndos 
endef




targets := $(foreach target, $(TARGETS), \
		$(eval $(call build_for,$(target),world.c)) \
	) 
targets += $(foreach target, $(TARGETCLASSIC), \
		$(eval $(call build_for,$(target),world.c,-clib=classic)) \
	)
targets += $(foreach target, $(TARGETANSI), \
		$(eval $(call build_for,$(target),ansitest.c,-clib=ansi)) \
	)
targets += $(foreach target, $(TARGETGENERIC), \
		$(eval $(call build_for,$(target),world_conio.c,--generic-console -clib=default -DGENCON)) \
	)
targets += $(foreach subtype, $(CPMSUBTYPES), \
		$(eval $(call build_for_subtype,cpm,world.c,-create-app,$(subtype))) \
	)


clean:
	@$(RM) -r bin
