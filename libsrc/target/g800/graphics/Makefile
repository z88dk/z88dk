include ../../../Make.config

TARGET ?= g850

SUBDIRS = 

CLEANDIRS = $(SUBDIRS:%=%-clean)

ASMFILES = $(wildcard *.asm) $(wildcard ansi/*.asm)
CFILES = $(wildcard *.c)
OBJECTS = $(ASMFILES:.asm=.o) $(CFILES:.c=.o)
AFLAGS = 


all: dirs subdirs-all $(addprefix obj/$(TARGET)/,$(OBJECTS))


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
	$(RM) */*.o */*/*.o

subdirs-clean: $(CLEANDIRS)

obj/$(TARGET)/%.o: %.asm
	$(Q)$(ASSEMBLER) -DFOR$(TARGET) $(AFLAGS) -I$(OUTPUT_DIRECTORY) -I$(Z88DK_LIB) -DSTANDARDESCAPECHARS -Oobj/$(TARGET) $^

obj/$(TARGET)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -o $@ $^

dirs:
	@mkdir -p obj/$(TARGET)

.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all TARGET=$(TARGET)

$(CLEANDIRS):
	$(MAKE) -C $(@:%-clean=%) clean
	$(RM) */*.o
