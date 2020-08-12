include ../../Make.config

TARGET ?= zx

SUBDIRS = tape games stdio newlib

ifeq ($(TARGET),zx)
  SUBDIRS += fzx fcntl rs232
endif

ifeq ($(TARGET),zxn)
  SUBDIRS += fzx fcntl 
endif

CLEANDIRS = $(SUBDIRS:%=clean-%)

ASMFILES = $(wildcard *.asm)
OBJECTS = $(ASMFILES:.asm=.o)

all: dirs subdirs-all $(addprefix obj/$(TARGET)/,$(OBJECTS))


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
	$(RM) */*.o */*/*.o

subdirs-clean: $(CLEANDIRS)

obj/$(TARGET)/%.o: %.asm
	$(Q)$(ASSEMBLER) -DFOR$(TARGET) -I../.. -I../../../lib/ $^
	@mv $(^:.asm=.o) $@

dirs:
	@mkdir -p obj/$(TARGET)

.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all TARGET=$(TARGET)

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
	$(RM) */*.o
