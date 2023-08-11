include ../../Make.config

SUBDIRS = 
CLEANDIRS = $(SUBDIRS:%=%-clean)

TARGET ?= test

ifeq ($(SUBTYPE),) 
SUBTYPE=$(TARGET)
OBJSUBDIR = $(TARGET)
ASMFLAGS = -DFOR$(TARGET)
else
OBJSUBDIR = $(SUBTYPE)
CFLAGS += -subtype=$(SUBTYPE)
ASMFLAGS = -DFOR$(SUBTYPE)
endif

CFILES = $(wildcard *.c)
ASMFILES = $(wildcard *.asm)

OBJECTS = $(CFILES:.c=.o) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)) $(SUBDIRS)

obj/$(OBJSUBDIR)/%.o: %.c
	$(ZCC) +$(TARGET) $(CFLAGS) -Ca$(ASMFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	$(ZCC) +$(TARGET) $(CFLAGS) -Ca$(ASMFLAGS) -o $@  $^

dirs:
	@mkdir -p obj/$(OBJSUBDIR)

clean: subdirs-clean
	$(RM) -fr obj zcc_opt.def *.err

.PHONY: $(SUBDIRS) $(SUBDIRS_CLEAN)

subdirs-clean: $(CLEANDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ all TARGET=$(TARGET)

$(CLEANDIRS):
	$(MAKE) -C $(@:%-clean=%) clean
	$(RM) */*.o
