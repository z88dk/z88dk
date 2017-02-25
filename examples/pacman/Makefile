CC=zcc
SREC_CAT=srec_cat
MAME=/c/mame/mame

C_FILES=dstar.c
OBJECT_FILES=$(C_FILES:%.c=%.o)

MAME_DIR=puckmod
MAME_FILES=namcopac.6e  namcopac.6f namcopac.6h  npacmod.6j

test: $(MAME_FILES:%=$(MAME_DIR)/%)
	$(MAME) $(MAME_DIR)

clean:
	rm -f $(MAME_FILES:%=$(MAME_DIR)/%)
	rm -f rom.o rom*.bin *.o
	rm -f zcc_opt.def

$(MAME_DIR)/namcopac.6e: rom.bin
	$(SREC_CAT) $< -binary -crop 0x0000 0x1000 -fill 0x00 0x0000 0x1000 -offset 0x0000 -o $@ -binary
$(MAME_DIR)/namcopac.6f: rom.bin
	$(SREC_CAT) $< -binary -crop 0x1000 0x2000 -fill 0x00 0x1000 0x2000 -offset -0x1000 -o $@ -binary
$(MAME_DIR)/namcopac.6h: rom.bin
	$(SREC_CAT) $< -binary -crop 0x2000 0x3000 -fill 0x00 0x2000 0x3000 -offset -0x2000 -o $@ -binary
$(MAME_DIR)/npacmod.6j: rom.bin
	$(SREC_CAT) $< -binary -crop 0x3000 0x4000 -fill 0x00 0x3000 0x4000 -offset -0x3000 -o $@ -binary

rom.bin: $(OBJECT_FILES)
	$(CC) +pacman -lm $(OBJECT_FILES) -o $@

src/%.o: %.asm
	$(CC) +pacman -c $<

src/%.o: %.c
	$(CC) +pacman -c $<

