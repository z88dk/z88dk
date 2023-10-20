#####
#
# This makefile is designed for compiling multi-target applications using z88dk's
# classic library.
#
# A final executable for a target is comprised of $(COMMON_SRCS) and all .asm and
# .c files located within the target's directory.


# Targets that you want to compile for (eg zx, multi8 etc)
TARGETS = 

# Name of the output binary
APPNAME = 

# Source files shared between all z88dk targets (eg $(wildcard *.c) $(wildcard *.asm))
COMMON_SRCS =  





#########
# Try not to modify below here
#########

# Override this, eg make Q= to print commands
Q ?= @


# Create a makefile target for each build we need (we only need this if we're using this
# makefile in a simple way)
ifneq ($(APPNAME),)
all: $(foreach target, $(TARGETS),  build/$(target)/$(APPNAME) )
endif

# We have some ports with subtypes so create targets for them
Z88DKTARGET_adam = coleco
ZCFLAGS_adam = -subtype=adam
ZLDFLAGS_adam =

Z88DKTARGET_aquarius_rom = aquarius
ZCFLAGS_aquarius_rom = -subtype=rom
ZLDFLAGS_aquarius_rom = 

Z88DKTARGET_aqplus = aquarius
ZCFLAGS_aqplus = -clib=aqplus
ZLDFLAGS_aqplus = 

Z88DKTARGET_bit90 = coleco
ZCFLAGS_bit90 = -subtype=bit90
ZLDFLAGS_bit90 = 

Z88DKTARGET_eg2000 = trs80
ZCFLAGS_eg2000 = -subtype=eg2000disk
ZLDFLAGS_eg2000 = 

Z88DKTARGET_galplus = gal
ZCFLAGS_galplus = -subtype=galaxyp
ZLDFLAGS_galplus = 

Z88DKTARGET_super80_vduem = super80
ZCFLAGS_super80_vduem = -clib=vduem
ZLDFLAGS_super80_vduem = 

Z88DKTARGET_msx_msxdos1 = msx
ZCFLAGS_msx_msxdos1 = -subtype=msxdos
ZLDFLAGS_msx_msxdos1 = 

Z88DKTARGET_msx_msxdos2 = msx
ZCFLAGS_msx_msxdos2 = -subtype=msxdos2
ZLDFLAGS_msx_msxdos1 = 

Z88DKTARGET_msx_rom = msx
ZCFLAGS_msx_rom = -subtype=rom
ZLDFLAGS_msx_rom = 

Z88DKTARGET_msx2_rom = msx
ZCFLAGS_msx2_rom = -subtype=rom2
ZLDFLAGS_msx2_rom = 

Z88DKTARGET_gl4000 = gl
ZCFLAGS_gl4000 = -clib=gl4000
ZLDFLAGS_gl4000 = 
Z88DKTARGET_gl6000 = gl
ZCFLAGS_gl6000 = -clib=gl6000sl
ZLDFLAGS_gl6000 = 

Z88DKTARGET_gamegear = sms
ZCFLAGS_gamegear = -subtype=gamegear
ZLDFLAGS_gamegear = 

Z88DKTARGET_m100_optrom = m100
ZCFLAGS_m100_optrom = -subtype=optrom
ZLDFLAGS_m100_optrom = 

Z88DKTARGET_pc6001_rom = pc6001
ZCFLAGS_pc6001_rom = -subtype=rom
ZLDFLAGS_pc6001_rom = 

Z88DKTARGET_pc88_disk = pc88
ZCFLAGS_pc88_disk = -subtype=disk
ZLDFLAGS_pc88_disk = 

Z88DKTARGET_vector06c_disk = vector06c
ZCFLAGS_vector06c_disk = -subtype=disk
ZLDFLAGS_vector06c_disk = 

Z88DKTARGET_sam_allram = sam
ZCFLAGS_sam_allram = -subtype=allram
ZLDFLAGS_sam_allram = 
Z88DKTARGET_sam_highram = sam
ZCFLAGS_sam_highram = -subtype=highram
ZLDFLAGS_sam_highram = 

Z88DKTARGET_sc3000_rom = sc3000
ZCFLAGS_sc3000_rom = -subtype=rom
ZLDFLAGS_sc3000_rom = 

Z88DKTARGET_svi_disk = svi
ZCFLAGS_svi_disk = -subtype=disk
ZLDFLAGS_svi_disk = 

Z88DKTARGET_svi_rom = svi
ZCFLAGS_svi_rom = -subtype=rom
ZLDFLAGS_svi_rom = 

Z88DKTARGET_svi_rom318 = svi
ZCFLAGS_svi_rom318 = -subtype=rom318
ZLDFLAGS_svi_rom318 = 

Z88DKTARGET_z88_app = z88
ZCFLAGS_z88_app = -subtype=app
ZLDFLAGS_z88_app = 

Z88DKTARGET_zxn_dot = zxn
ZCFLAGS_zxn_dot = -clib=classic -subtype=dot
ZLDFLAGS_zxn_dot = -lesxdos

Z88DKTARGET_zx_rom = zx
ZCFLAGS_zx_rom = -subtype=rom
ZLDFLAGS_zx_rom = -lndos


# Setup the CP/M mappings to +cpm
CPMSUBTYPES = aussie px pxansi px8 pxansi px4 px4ansi einstein einstein256 attache osborne1 kaypro83 \
	kaypro84 mz2500 microbee qc10 nascom tiki100 svi dmv adam smc777 pasopia \
	msx bic excali64 lynx x1 rc700 fp1100 zxplus3 vector06c bondwell bondwell2  \
	cpc pcw40 pcw80 corvette nabu mbc200 mbc1100 mbc1160 mbc2000 x820 partner v1050 \
	tim011 hz89 hz100 ptcpm

define setup_cpm_subtypes
Z88DKTARGET_cpm_$(1) = cpm
ZCFLAGS_cpm_$(1)= -subtype=$(1)
ZLDFLAGS_cpm_$(1) = 
endef

$(foreach subtype, $(CPMSUBTYPES), \
    $(eval $(call setup_cpm_subtypes,$(subtype))) \
)
Z88DKTARGET_cpm_8080 = cpm
ZCFLAGS_cpm_8080 = -clib=8080
ZLDFLAGS_cpm_8080 = 


# ZXN is special, to target classic we need -clib=classic
ZCFLAGS_zxn = -clib=classic
ZLDFLAGS_zxn = 


# Function to setup defaults for a target
define setup_target
Z88DKTARGET_$(1) ?= $(1)
ZLDFLAGS_$(1) += $(shell if [ -f $(1)/zpragma.inc ]; then  echo '-pragma-include:$(1)/zpragma.inc'; fi)
endef




# Functions to build the makefile
# $(1) = target
# $(2) = source file
# $(3) = $(basename binary name)
define build_ofile_asm
build/$(1)/$(patsubst %.asm,%.o,$(2)): $(2) 
	@mkdir -p $(dir build/$(1)/$(2))
	$(Q)zcc +$(Z88DKTARGET_$(1)) $(CFLAGS) $(CFLAGS_$(1)) $(CFLAGS_$(basename $(3))) $(CFLAGS_$(1)_$(basename $(3))) $(ZCFLAGS_$(1)) -o $$@ -c $(2)
endef

define build_ofile
build/$(1)/$(patsubst %.c,%.o,$(2)): $(2) 
	@mkdir -p $(dir build/$(1)/$(2))
	$(Q)zcc +$(Z88DKTARGET_$(1)) $(CFLAGS) $(CFLAGS_$(1)) $(CFLAGS_$(basename $(3))) $(CFLAGS_$(1)_$(basename $(3))) $(ZCFLAGS_$(1)) -I$(1) -o $$@ -c $(2)
endef


# $(1) = target
# $(2) = appname
# $(3) = common_srcs
define build_target

# Define a short cut to compile for a particular machine: make zx for example
$(1): build/$(1)/$(2)
.PHONY: $(1)

# And the full rule
# $(1) = target
# $(2) = binary name
build/$(1)/$(2): $(addprefix build/$(1)/,$(patsubst %.c,%.o,$(filter %.c,$(3)))) \
		$(addprefix build/$(1)/,$(patsubst %.asm,%.o,$(filter %.asm,$(3)))) \
		$(addprefix build/$(1)/,$(patsubst %.c,%.o,$(wildcard $(target)/*.c))) \
		$(addprefix build/$(1)/,$(patsubst %.asm,%.o,$(wildcard $(target)/*.asm))) 
	$(Q)zcc +$(Z88DKTARGET_$(1)) -m -o $$@ $$^ $(CFLAGS) $(LDFLAGS) $(CFLAGS_$(1)) $(CFLAGS_$(basename $(2))) $(CFLAGS_$(1)_$(basename $(2))) $(ZCFLAGS_$(1)) $(LDFLAGS_$(1)) $(LDFLAGS_$(basename $(2))) $(LDFLAGS_$(1)_$(basename $(2)))  $(ZLDFLAGS_$(1)) -create-app 
# delete object files to solve problem with appmake +zx80 creating a .o file
# that is a tape image and not an object file, causing a second make to fail
ifeq ($(1),zx80)
	$(Q)$(RM) build/$(1)/*.o
endif
endef


# $(1) = target
# $(2) = binary name
# $(3) = common sources
define build_app
    $(foreach target, $(1), \
		$(eval $(call setup_target,$(target))) \
		$(eval $(call build_target,$(target),$(strip $(2)),$(3))) \
		$(foreach file, $(filter %.c,$(3)) $(wildcard $(target)/*.c) , \
			$(eval $(call build_ofile,$(target),$(file),$(basename $(2))))  \
		) \
		$(foreach file, $(filter %.asm,$(3)) $(wildcard $(target)/*.asm) , \
			$(eval $(call build_ofile_asm,$(target),$(file),$(basename $(2))))  \
		) \
	)
endef



$(foreach app, $(APPNAME), $(eval $(call build_app, $(TARGETS), $(app), $(COMMON_SRCS))) ) 

print-% : ; $(info $* is a $(flavor $*) variable set to [$($*)]) @true


# And build all the required rules

# At least clean is simple
clean:	
	$(Q)$(RM) -r build
