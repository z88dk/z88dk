AQUARIUS_SOURCES := $(shell find target/aquarius -type f -name '*.asm')
AQUARIUS_CFILES := $(shell find target/aquarius -type f -name '*.c')
AQUARIUS_OFILES := $(addprefix target/aquarius/obj/aquarius/,$(AQUARIUS_CFILES:.c=.o))

AQUARIUS_TARGETS := target/aquarius/obj/target-aquarius-aquarius $(AQUARIUS_OFILES) classic/games/obj/.stamp-aquarius classic/gfx/obj/.stamp-aquarius

CLEAN += target-aquarius-clean

target-aquarius: $(AQUARIUS_TARGETS)

.PHONY: target-aquarius target-aquarius-clean

$(eval $(call buildtargetasm,target/aquarius,z80,aquarius,-mz80,$(AQUARIUS_SOURCES),$(AQUARIUS_SOURCES)))

target/aquarius/obj/aquarius/target/aquarius/%.o: target/aquarius/%.c
	@mkdir -p $(dir $@)
	cd target/aquarius/fcntl && $(patsubst @%,%,$(ZCC)) +aquarius $(CFLAGS) -c -o $(abspath $@) $(notdir $<)

target-aquarius-clean:
	$(RM) -fr target/aquarius/obj
