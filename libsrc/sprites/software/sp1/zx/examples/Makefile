ZCC=zcc +zx -vn -compiler=sdcc
#CFLAGS=-c --list -s --c-code-in-asm
#LDFLAGS=-lsp1-zx -lndos -m
CFLAGS=-c
LDFLAGS=-lsp1-zx -lndos

.PHONY: clean all

##
## TAP targets
##

TAP_TARGETS=ex0.tap \
	ex1.tap \
	ex2a.tap ex2b.tap ex2c.tap ex2d.tap ex2e.tap ex2f.tap ex2g.tap ex2h.tap \
	ex3a.tap \
	ex5e.tap

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

all: $(TAP_TARGETS)

build: clean all
	@-rm *.o *.bin

clean:
	@echo "Cleaning up SP1 examples..."
	@-rm -f *.o *.bin *.tap *.c.asm *.map *.lis *.sym
