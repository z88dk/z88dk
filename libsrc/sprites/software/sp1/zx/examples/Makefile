ZCC=zcc +zx -vn -compiler=sdcc
CFLAGS=-c --list -s --c-code-in-asm
LDFLAGS=-lsp1-zx -lndos -m

.PHONY: clean all

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

all: ex0.tap ex1.tap ex5e.tap

build: clean all

clean:
	@echo "Cleaning up SP1 examples..."
	@-rm -f *.o *.bin *.tap *.c.asm *.map *.lis *.sym
