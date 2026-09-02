include ../../Make.config

TARGET = nabu

SUBDIRS = retronet hcca
CLEANDIRS = $(SUBDIRS:%=%-clean)

ASMFILES = $(wildcard *.asm)
OBJECTS = $(ASMFILES:.asm=.o) 

all: subdirs-all $(addprefix obj/$(TARGET)/,$(OBJECTS))


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o

subdirs-clean: $(CLEANDIRS)

obj/$(TARGET)/%.o: %.asm
	@$(ASSEMBLER) -DFOR$(TARGET) -I../.. -Oobj/$(TARGET) $^

# Order-only: dirs must finish before any object compiles. See Make.config.
$(addprefix obj/$(TARGET)/,$(OBJECTS)): | dirs

dirs:
	$(Q)mkdir -p obj/$(TARGET)

.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:%-clean=%) clean
	$(RM) */*.o
