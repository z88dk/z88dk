include ../../Make.config

TARGET ?= ti82

SUBDIRS = fcntl
CLEANDIRS = $(SUBDIRS:%=%-clean)

ASMFILES = $(wildcard *.asm)
CFILES = $(wildcard *.c)
OBJECTS = $(ASMFILES:.asm=.o) $(CFILES:.c=.o)

all: dirs subdirs-all $(addprefix obj/$(TARGET)/,$(OBJECTS))


subdirs-all: $(SUBDIRS)

subdirs-clean: $(SUBDIRS_CLEAN)


clean: subdirs-clean
	$(RM) -r obj
	$(RM) zcc_opt.def *.err *.o
	$(RM) */*.o
	$(RM) */*/*.o

subdirs-clean: $(CLEANDIRS)

obj/$(TARGET)/%.o: %.c
	@$(CC) -DFOR$(TARGET) -I../..  $^
	@mv $(^:.asm=.o) $@

obj/$(TARGET)/%.o: %.asm
	@$(ASSEMBLER) -DFOR$(TARGET) -I../..  $^
	@mv $(^:.asm=.o) $@

dirs:
	@mkdir -p obj/$(TARGET)

.PHONY:	subdirs-all $(SUBDIRS) $(SUBDIRS_CLEAN)

$(SUBDIRS):
	$(MAKE) -C $@ all

$(CLEANDIRS):
	$(MAKE) -C $(@:%-clean=%) clean
	$(RM) */*.o
