include ../../../Make.config

TARGET = c128

SUBDIRS = 
CLEANDIRS = $(SUBDIRS:%=%-clean)

CFILES = $(wildcard *.c)
ASMFILES = $(wildcard *.asm)
OBJECTS = $(ASMFILES:.asm=.o) $(CFILES:.c=.o)

all: dirs subdirs-all $(addprefix obj/$(TARGET)/,$(OBJECTS))


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o

subdirs-clean: $(CLEANDIRS)

obj/$(TARGET)/%.o: %.asm
	@$(ASSEMBLER) -DFOR$(TARGET) -I../.. -Oobj/$(TARGET) $^

obj/$(TARGET)/%.o: %.c
	$(ZCC) +$(TARGET) -mz80 $(CFLAGS) -o $@  $^

dirs:
	@mkdir -p obj/$(TARGET)

.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:%-clean=%) clean
	$(RM) */*.o
