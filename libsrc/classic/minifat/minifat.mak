# Classic mini-FAT. The core is one object per CPU (z80/fatfs.asm,
# 8085/fatfs.asm). Optional ChaN calls are separate files in this
# directory and are linked only when a program calls them.
# fat_bss.asm is the shared RAM block. A target that wants the core
# in its library lists classic/minifat/minifat.lst, the same way
# osca lists sdcard.

MINIFAT_CORE_AFILES := fatfs.asm
MINIFAT_SHARED_AFILES := fat_bss.asm

MINIFAT_OBJS := \
	$(addprefix classic/minifat/z80/obj/z80/, $(MINIFAT_CORE_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/8085/obj/8085/, $(MINIFAT_CORE_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/obj/z80/, $(MINIFAT_SHARED_AFILES:.asm=.o)) \
	$(addprefix classic/minifat/obj/8085/, $(MINIFAT_SHARED_AFILES:.asm=.o))

OBJS += $(MINIFAT_OBJS)
CLEAN += classic-minifat-clean

$(eval $(call buildbit,classic/minifat,z80,test))
$(eval $(call buildbit,classic/minifat,8085,test,,-m8085))
$(eval $(call buildbit,classic/minifat/z80,z80,test))
$(eval $(call buildbit,classic/minifat/8085,8085,test,,-m8085))

classic-minifat: $(MINIFAT_OBJS)

.PHONY: classic-minifat classic-minifat-clean

classic-minifat-clean:
	$(RM) -fr classic/minifat/obj classic/minifat/z80/obj classic/minifat/8085/obj
