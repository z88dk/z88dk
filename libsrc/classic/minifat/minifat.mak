# Classic mini-FAT. One core per CPU, under z80, 8085, 8080, gbz80,
# and vm1. fat_sync stays in that core. The other C calls and the
# f_* calls are one file each in that CPU directory, and are linked
# only when a program calls them.
# fat_bss.asm is the shared RAM block. A target that wants the core
# in its library lists classic/minifat/minifat.lst (or the 8085,
# 8080, gbz80, or vm1 list), the same way osca lists sdcard.

MINIFAT_SHARED_AFILES := fat_bss.asm
MINIFAT_Z80_AFILES := $(notdir $(wildcard classic/minifat/z80/*.asm))
MINIFAT_8085_AFILES := $(notdir $(wildcard classic/minifat/8085/*.asm))
MINIFAT_8080_AFILES := $(notdir $(wildcard classic/minifat/8080/*.asm))
MINIFAT_GBZ80_AFILES := $(notdir $(wildcard classic/minifat/gbz80/*.asm))
MINIFAT_VM1_AFILES := $(notdir $(wildcard classic/minifat/vm1/*.asm))

MINIFAT_OBJS := \
	$(addprefix classic/minifat/z80/obj/z80/, $(MINIFAT_Z80_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/8085/obj/8085/, $(MINIFAT_8085_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/8080/obj/8080/, $(MINIFAT_8080_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/gbz80/obj/gbz80/, $(MINIFAT_GBZ80_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/vm1/obj/vm1/, $(MINIFAT_VM1_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/obj/z80/, $(MINIFAT_SHARED_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/obj/8085/, $(MINIFAT_SHARED_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/obj/8080/, $(MINIFAT_SHARED_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/obj/gbz80/, $(MINIFAT_SHARED_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/obj/vm1/, $(MINIFAT_SHARED_AFILES:.asm=.o))

OBJS += $(MINIFAT_OBJS)
CLEAN += classic-minifat-clean

$(eval $(call buildbit,classic/minifat,z80,test))
$(eval $(call buildbit,classic/minifat,8085,test,,-m8085))
$(eval $(call buildbit,classic/minifat,8080,test,,-m8080))
$(eval $(call buildbit,classic/minifat,gbz80,test,,-mgbz80))
$(eval $(call buildbit,classic/minifat/z80,z80,test))
$(eval $(call buildbit,classic/minifat/8085,8085,test,,-m8085))
$(eval $(call buildbit,classic/minifat/8080,8080,test,,-m8080))
$(eval $(call buildbit,classic/minifat/gbz80,gbz80,test,,-mgbz80))
$(eval $(call buildbit,classic/minifat,vm1,test,,-mvm1))
$(eval $(call buildbit,classic/minifat/vm1,vm1,test,,-mvm1))

classic-minifat: $(MINIFAT_OBJS)

.PHONY: classic-minifat classic-minifat-clean

classic-minifat-clean:
	$(RM) -fr classic/minifat/obj classic/minifat/z80/obj classic/minifat/8085/obj classic/minifat/8080/obj classic/minifat/gbz80/obj classic/minifat/vm1/obj
