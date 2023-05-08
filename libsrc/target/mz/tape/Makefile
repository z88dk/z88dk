include ../../../Make.config

TARGET ?= mz

SUBDIRS = 

CFLAGS += -I$(Z88DK_INCLUDE)/arch/mz

CLEANDIRS = $(SUBDIRS:%=clean-%)

ASMFILES = $(wildcard *.asm)
CFILES = $(wildcard *.c)
OBJECTS = $(ASMFILES:.asm=.o) $(CFILES:.c=.o)

all: dirs subdirs-all $(addprefix obj/$(TARGET)/,$(OBJECTS))


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
	$(RM) */*.o */*/*.o

subdirs-clean: $(CLEANDIRS)

obj/$(TARGET)/%.o: %.asm
	@$(ASSEMBLER) -DFOR$(TARGET) -I../.. -Oobj/$(TARGET) $^

obj/$(TARGET)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@ $^

dirs:
	@mkdir -p obj/$(TARGET)

.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all TARGET=$(TARGET)

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
	$(RM) */*.o
