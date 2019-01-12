
TARGETS = abc80 abc800 ace alphatro aquarius bee c128 c7420 coleco cpc cpm enterprise fp1100 g800 gal kc lambda laser500 lynx m5 mc1000 msx mtx multi8 mz nascom nc newbrain osca oz p2000 pacman pc6001 pps pv1000 pv2000 rcmx000 rx78 sam sc3000 sos spc1000 srr svi test ti82 ti83 ti85 ti86 ti8x trs80 ts2068 vg5k vz x07 x1 z1013 z9001 z88 zx zx80 zx81 

TARGETANSI = abc80 ace aquarius bee cpc gal mc1000 msx mtx mz nascom osca p2000 pc6001 pps sam sc3000 svi ti82 ti83 ti85 ti86 ti8x ts2068 vz x1 z1013 z88 zx z9001

TARGETGENERIC = abc80 ace alphatro aquarius bee cpc coleco fp1100 laser500 mc1000 nascom pv1000 pps rx78 spc1000 srr super80 trs80 vg5k vz z1013 zx80 zx81 msx pv2000 sc3000 svi m5 mtx multi8 z80tvgame z9001

EXES = $(addprefix bin/,$(addsuffix /world, $(TARGETS))) $(addprefix bin/,$(addsuffix /ansitest, $(TARGETANSI))) $(addprefix bin/,$(addsuffix /world_conio, $(TARGETGENERIC)))

all: $(EXES)

define build_for
bin/$(1)/$(basename $(2)): $(2)
	@mkdir -p bin/$(1)
	zcc +$(1)  $(2) $(3) -o $$@ -lndos
endef





targets := $(foreach target, $(TARGETS), \
		$(eval $(call build_for,$(target),world.c)) \
	) 
targets += $(foreach target, $(TARGETANSI), \
		$(eval $(call build_for,$(target),ansitest.c,-clib=ansi)) \
	)
targets += $(foreach target, $(TARGETGENERIC), \
		$(eval $(call build_for,$(target),world_conio.c,-pragma-redirect:fputc_cons=fputc_cons_generic -clib=default)) \
	)

clean:
	@$(RM) -r bin
