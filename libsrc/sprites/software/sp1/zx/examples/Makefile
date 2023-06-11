# use this for SDCC + Classic
ZCC=zcc +zx -vn -compiler=sdcc
LDFLAGS=-lsp1-zx -lndos

# use this for SCCZ80 + Classic
# ZCC=zcc +zx -vn
# LDFLAGS=-lsp1-zx -lndos

CFLAGS=-c

.PHONY: clean all build

##########################
## sources and taps
## just add standalone .c files
## to this dir and they will be
## compiled
##########################

SRCS=$(wildcard *.c)
TAPS=$(SRCS:.c=.tap) ex6b.tap

##########################
## implicit rules
##########################

#.PRECIOUS: %.o

%.o: %.c
	$(ZCC) $(CFLAGS) $(INCLUDE) $< -o $@

%.o: %.asm
	$(ZCC) $(CFLAGS) $(INCLUDE) $< -o $@

%.tap: %.o
	$(ZCC) $(LDFLAGS) $(LIBS) -create-app $< -o $(shell basename $@ .tap).bin
	@-rm $(shell basename $@ .tap)*.bin

##########################
## target rules
##########################

all: $(TAPS)

ex6b.tap:
	$(ZCC) $(LDFLAGS) $(LIBS) -create-app ex6b/ex6b.c ex6b/ex6b_asm.asm -o ex6b.bin
	@-rm ex6b*.bin

build: clean all

clean:
	@-rm -f *.o *.bin *.tap *.c.asm *.map *.lis *.sym
