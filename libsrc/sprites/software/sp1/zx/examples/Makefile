ZCC=zcc +zx -vn -compiler=sdcc
#CFLAGS=-c --list -s --c-code-in-asm
#LDFLAGS=-lsp1-zx -lndos -m
CFLAGS=-c
LDFLAGS=-lsp1-zx -lndos

.PHONY: clean all

##########################
## sources and taps
## just add standalone .c files
## to this dir and they will be
## compiled
##########################

SRCS=$(wildcard *.c)
TAPS=$(SRCS:.c=.tap)

##########################
## implicit rules
##########################

.PRECIOUS: %.o

%.o: %.c
	$(ZCC) $(CFLAGS) $(INCLUDE) $< -o $@

%.o: %.asm
	$(ZCC) $(CFLAGS) $(INCLUDE) $< -o $@

%.tap: %.o
	$(ZCC) $(LDFLAGS) $(LIBS) -create-app $< -o $(shell basename $@ .tap).bin

##########################
## target rules
##########################

all: $(TAPS) ex6b.tap

ex6b.tap:
	$(ZCC) $(LDFLAGS) $(LIBS) -create-app ex6b/ex6b.c ex6b/ex6b_asm.asm -o ex6b.bin

build: clean all
	@-rm *.o *.bin

clean:
	@echo "Cleaning up SP1 examples..."
	@-rm -f *.o *.bin *.tap *.c.asm *.map *.lis *.sym
