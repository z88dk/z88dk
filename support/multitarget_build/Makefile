#####
#
# This makefile is designed for compiling multi-target applications using z88dk's
# classic library.
#
# A final executable for a target is comprised of $(COMMON_SRCS) and all .asm and
# .c files located within the targets directory.


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

# Setup the CP/M mappings to +cpm
CPMSUBTYPES = px pxansi px8 pxansi px4 px4ansi einstein attache osborne1 kaypro83 \
	kaypro84 mz2500 microbee qc10 nascom tiki100 svi dmv adam smc777 pasopia \
	msx bic excali64 lynx x1 rc700 fp1100 zxplus3 vector06c

define setup_cpm_subtypes
Z88DKTARGET_cpm_$(1) = cpm
ZCFLAGS_cpm_$(1)= -subtype=$(1)
ZLDFLAGS_cpm_$(1) = 
endef

$(foreach subtype, $(CPMSUBTYPES), \
    $(eval $(call setup_cpm_subtypes,$(subtype))) \
)


# ZXN is special, to target classic we need -clib=classic
ZCFLAGS_zxn = -clib=classic
ZLDFLAGS_zxn = 


# Function to setup defaults for a target
define setup_target
Z88DKTARGET_$(1) ?= $(1)
ZLDFLAGS_$(1) += $(shell if [ -f $(1)/zpragma.inc ]; then  echo '-pragma-include:$(1)/zpragma.inc'; fi)
endef




# Functions to build the makefile
define build_ofile_asm
build/$(1)/$(patsubst %.asm,%.o,$(2)): $(2) 
	@mkdir -p $(dir build/$(1)/$(2))
	$(Q)zcc +$(Z88DKTARGET_$(1)) $(CFLAGS) $(CFLAGS_$(1)) $(ZCFLAGS_$(1)) -o $$@ -c $(2)
endef

define build_ofile
build/$(1)/$(patsubst %.c,%.o,$(2)): $(2) 
	@mkdir -p $(dir build/$(1)/$(2))
	$(Q)zcc +$(Z88DKTARGET_$(1)) $(CFLAGS) $(ZCFLAGS_$(1)) -I$(1) -o $$@ -c $(2)
endef


# $(1) = target
# $(2) = appname
# $(3) = common_srcs
define build_target

# Define a short cut to compile for a particular machine: make zx for example
$(1): build/$(1)/$(2)
.PHONY: $(1)

# And the full rule
build/$(1)/$(2): $(addprefix build/$(1)/,$(patsubst %.c,%.o,$(filter %.c,$(3)))) \
		$(addprefix build/$(1)/,$(patsubst %.asm,%.o,$(filter %.asm,$(3)))) \
		$(addprefix build/$(1)/,$(patsubst %.c,%.o,$(wildcard $(target)/*.c))) \
		$(addprefix build/$(1)/,$(patsubst %.asm,%.o,$(wildcard $(target)/*.asm))) 
	$(Q)zcc +$(Z88DKTARGET_$(1)) -m -o $$@ $$^ $(CFLAGS) $(LDFLAGS) $(CFLAGS_$(1)) $(ZCFLAGS_$(1)) $(LDFLAGS_$(1)) $(ZLDFLAGS_$(1)) -create-app 
endef


# $(1) = target
# $(2) = binary name
# $(3) = common sources
define build_app
    $(foreach target, $(1), \
		$(warning Build target $(target) app <$(strip $(2))>)
		$(eval $(call setup_target,$(target))) \
		$(eval $(call build_target,$(target),$(strip $(2)),$(3))) \
		$(foreach file, $(filter %.c,$(3)) $(wildcard $(target)/*.c) , \
			$(eval $(call build_ofile,$(target),$(file)))  \
		) \
		$(foreach file, $(filter %.asm,$(3)) $(wildcard $(target)/*.asm) , \
			$(eval $(call build_ofile_asm,$(target),$(file)))  \
		) \
	)
endef



$(foreach app, $(APPNAME), $(eval $(call build_app, $(TARGETS), $(app), $(COMMON_SRCS))) ) 

# And build all the required rules

# At least clean is simple
clean:	
	$(Q)$(RM) -r build
