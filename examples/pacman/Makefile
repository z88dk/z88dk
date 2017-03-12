CC=zcc 
MV=mv
MAME=/c/mame/mame

C_FILES=dstar.c
OBJECT_FILES=$(C_FILES:%.c=%.o)

MAME_DIR=puckmod
MAME_FILES=namcopac.6e  namcopac.6f namcopac.6h  npacmod.6j

all: $(MAME_FILES:%=$(MAME_DIR)/%)

test: all
	$(MAME) $(MAME_DIR)

clean:
	rm -f $(MAME_FILES:%=$(MAME_DIR)/%)
	rm -f rom.o rom*.bin *.o
	rm -f zcc_opt.def

$(MAME_DIR)/namcopac.6e: rom.bin
	$(MV)  rom.0a $@
$(MAME_DIR)/namcopac.6f: rom.bin
	$(MV)  rom.0b $@
$(MAME_DIR)/namcopac.6h: rom.bin
	$(MV)  rom.0c $@
$(MAME_DIR)/npacmod.6j: rom.bin
	$(MV)  rom.0d $@

rom.bin: $(OBJECT_FILES)
	$(CC) +pacman -vn -lm $(OBJECT_FILES) -o $@

%.o: %.asm
	$(CC) +pacman -vn -c $<

%.o: %.c
	$(CC) +pacman -vn -c $<
