# 256-byte floppy to 512-byte LBA. One 8080 source, built into each
# classic library. A target supplies floppy256_sector and lists
# classic/floppy/floppy256.lst when it builds from a list.

FLOPPY_AFILES := $(notdir $(wildcard classic/floppy/*.asm))

FLOPPY_OBJS := \
	$(addprefix classic/floppy/obj/z80/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/r2ka/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/r4k/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/ixiy/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/z80n/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/z180/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/kc160/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/ez80_z80/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/8080/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/8085/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/gbz80/, $(FLOPPY_AFILES:.asm=.o)) \
	$(addprefix classic/floppy/obj/vm1/, $(FLOPPY_AFILES:.asm=.o))

OBJS += $(FLOPPY_OBJS)
CLEAN += floppy-clean

$(eval $(call buildbit,classic/floppy,z80,test))
$(eval $(call buildbit,classic/floppy,ixiy,test,-Ca-IXIY,-IXIY))
$(eval $(call buildbit,classic/floppy,r2ka,test,-clib=rabbit,-mr2ka))
$(eval $(call buildbit,classic/floppy,r4k,test,-clib=rabbitr4k,-mr4k))
$(eval $(call buildbit,classic/floppy,z80n,test,-clib=z80n,-mz80n))
$(eval $(call buildbit,classic/floppy,z180,test,-clib=z180,-mz180))
$(eval $(call buildbit,classic/floppy,kc160,test,-clib=kc160,-mkc160))
$(eval $(call buildbit,classic/floppy,ez80_z80,test,-clib=ez80_z80,-mez80_z80))
$(eval $(call buildbit,classic/floppy,8080,test,-clib=8080,-m8080))
$(eval $(call buildbit,classic/floppy,8085,test,-clib=8085,-m8085))
$(eval $(call buildbit,classic/floppy,gbz80,test,-clib=gbz80,-mgbz80))
$(eval $(call buildbit,classic/floppy,vm1,test,-clib=vm1,-mvm1))

floppy: $(FLOPPY_OBJS)

.PHONY: floppy floppy-clean

floppy-clean:
	$(RM) -fr classic/floppy/obj classic/floppy/*.o
