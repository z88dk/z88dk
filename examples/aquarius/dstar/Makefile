CC:=zcc
CFLAGS:= +aquarius --generic-console -m -DSOUND -create-app

PROJECTS:= build/aquarius/_dstar.caq build/aqplus/dstar.aqx

.PHONY: all clean

all: build $(PROJECTS)

clean:
	rm -f *.caq *.aqx *.map *.bin
	rm -rf build

build/aquarius/_dstar.caq: dstar.c dstar.h
	$(CC) $(CFLAGS) $< -obuild/aquarius/dstar.bin

build/aqplus/dstar.aqx: dstar.c dstar.h
	$(CC) $(CFLAGS) -subtype=aqx $< -obuild/aqplus/dstar.bin

build:
	mkdir -p build/aquarius
	mkdir -p build/aqplus
