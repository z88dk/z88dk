PROJECT_NAME:=TurboSound
ASSRC:=$(wildcard *.asm)
CSRC:=$(wildcard *.c)

.PHONY: all clean run

all: build build/aqplus/$(PROJECT_NAME).bin

dis: all
	z88dk-dis -x build/aqplus/$(PROJECT_NAME).map -o CRT_ORG_CODE build/aqplus/$(PROJECT_NAME).bin | less

run: all
	aquarius_emu -u build/aqplus -t "\nrun $(PROJECT_NAME).aqx\n"

build/aqplus/%.bin: $(ASSRC) $(CSRC)
	zcc +aquarius -pragma-include:zpragma.inc -m -clib=aqplus $(ASSRC) $(CSRC) -o $@ -create-app -subtype=aqx

build:
	mkdir -p build/aqplus

clean:
	rm -f *.bin *.aqx *.map
	rm -rf build

