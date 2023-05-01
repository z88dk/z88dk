#

include ../../Make.config

vpath %.c ../cimpl/

AFILES  = $(wildcard c/sccz80/*.asm) $(wildcard z80/*asm)
CFILES  = tofix16.c fromfix16.c
OBJECTS = $(AFILES:.asm=.o) $(CFILES:.c=.o)

CFLAGS +=  -math-z88 -D__Z88__ -D__NATIVE_MATH__ -DFLOAT_IS_48BITS

all: dirs $(OUTPUT_DIRECTORY)/mzx.lib $(OUTPUT_DIRECTORY)/mzx_tiny.lib \
	$(OUTPUT_DIRECTORY)/m2068.lib \
	$(OUTPUT_DIRECTORY)/mlambda.lib $(OUTPUT_DIRECTORY)/mlambda_tiny.lib \
	$(OUTPUT_DIRECTORY)/m81.lib $(OUTPUT_DIRECTORY)/m81_tiny.lib


# $(1) = flavour
# $(2) = extra flags
define build_lib
$(1): $(OUTPUT_DIRECTORY)/$(1).lib
.PHONY: $(1)


$(OUTPUT_DIRECTORY)/$(1).lib: $(addprefix obj/$(1)/, $(OBJECTS))
	TYPE=$(1) $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/$(1).lib @zxm.lst

obj/$(1)/%.o: %.c
	$(ZCC) +test $(CFLAGS) -o $$@  $$^

obj/$(1)/%.o: %.asm
	$(Q)$(ASSEMBLER) -I../ -I$(Z88DK_LIB) -mz80 -D__CLASSIC $(2) $$^
	@mv $$(^:.asm=.o) $$@
endef

$(eval $(call build_lib,mzx,-DFORzx))
$(eval $(call build_lib,mzx_tiny,-DTINYMODE -DFORzx))
$(eval $(call build_lib,m2068,-DFORts2068))
$(eval $(call build_lib,m81,-IXIY -DFORzx81))
$(eval $(call build_lib,m81_tiny,-DTINYMODE -IXIY -DFORzx81))
$(eval $(call build_lib,mlambda,-IXIY -DFORlambda))
$(eval $(call build_lib,mlambda_tiny,-DTINYMODE -IXIY -DFORlambda))


dirs:
	@mkdir -p obj/mzx/c/sccz80 
	@mkdir -p obj/mzx_tiny/c/sccz80 
	@mkdir -p obj/m2068/c/sccz80 
	@mkdir -p obj/m81/c/sccz80 
	@mkdir -p obj/m81_tiny/c/sccz80 
	@mkdir -p obj/mlambda/c/sccz80 
	@mkdir -p obj/mlambda_tiny/c/sccz80 

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

