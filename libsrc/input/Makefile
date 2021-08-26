#

include ../Make.config

CFILES = $(wildcard *.c)
AFILES = $(wildcard *.asm) 
OFILES = $(CFILES:.c=.o) $(AFILES:.asm=.o)


all: dirs $(addprefix obj/8080/,$(OFILES)) $(addprefix obj/z80/,$(OFILES)) $(addprefix obj/r2k/,$(OFILES)) $(addprefix obj/ixiy/,$(OFILES)) $(addprefix obj/z80n/,$(OFILES))


obj/8080/%.o: %.asm
	$(ZCC) +test -m8080 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/gbz80/%.o: %.asm
	$(ZCC) +test -mgbz80 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/r2k/%.o: %.asm
	$(ZCC) +test -mr2ka $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/z80/%.o: %.asm
	$(ZCC) +test -mz80 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/z80n/%.o: %.asm
	$(ZCC) +test -mz80n $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/ixiy/%.o: %.asm
	$(ZCC) +test -mz80 -Ca-IXIY $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^


.PHONY: dirs
dirs:
	@mkdir -p obj/z80 obj/r2k obj/8080 obj/gbz80 obj/ixiy obj/z80n



clean:  
	$(RM) *.o* *.sym *.map zcc_opt.def *.i */*.o
	$(RM) -fr obj zcc_opt.def
