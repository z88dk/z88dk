PROJECT_NAME:=main
ASSRC:=$(wildcard *.asm)
CSRC:=$(wildcard *.c)

EMU = aquarius_emu

.PHONY: all clean run

all: build $(PROJECT_NAME).bin

run: all
	$(EMU) -u . 

%.bin: $(ASSRC) $(CSRC)
	zcc +aquarius -m -clib=aqplus $(ASSRC) $(CSRC) -o $@ -create-app -subtype=aqx

build:
	mkdir -p build/aqplus

clean:
	rm -f *.bin *.aqx *.map
	rm -rf build

