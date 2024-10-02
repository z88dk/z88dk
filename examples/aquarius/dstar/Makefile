CC:=zcc
CFLAGS:= +aquarius --generic-console -m -DSOUND -create-app

PROJECTS:= _dstar.caq dstar.aqx

.PHONY: all clean

all: $(PROJECTS)

clean:
	rm -f *.caq *.aqx *.map *.bin

_dstar.caq: dstar.c dstar.h
	$(CC) $(CFLAGS) $< -odstar.bin

dstar.aqx: dstar.c dstar.h
	$(CC) $(CFLAGS) -subtype=aqx $< -odstar_aqplus.bin
