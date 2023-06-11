include ../../Make.config

TARGET ?= ti82

SUBDIRS = 
CLEANDIRS = $(SUBDIRS:%=%-clean)

ASMFILES = $(wildcard *.asm) $(wildcard */*.asm) $(wildcard */*/*.asm)
OBJECTS = $(ASMFILES:.asm=.o)

all: dirs subdirs-all $(addprefix obj/$(TARGET)/,$(OBJECTS))


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
	$(RM) */*.o
	$(RM) */*/*.o

subdirs-clean: $(CLEANDIRS)

obj/$(TARGET)/%.o: %.asm
	$(Q)$(ASSEMBLER) -DFOR$(TARGET) -DSTANDARDESCAPECHARS  -DPACKEDFONT -I../.. -Oobj/$(TARGET) $^

dirs:
	@mkdir -p obj/$(TARGET)

.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:%-clean=%) clean
	$(RM) */*.o
