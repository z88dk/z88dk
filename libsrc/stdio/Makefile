#

include ../Make.config

CFILES = $(wildcard *.c)
ZSFILES = $(wildcard zsock/*.c) 
AFILES = $(wildcard *.asm) $(wildcard conio/*.asm)
AFILES_8080 = $(wildcard *.asm) $(wildcard conio/*.asm)
AFILES_GBZ80 = $(filter-out $(wildcard *scanf*.asm), $(wildcard *.asm)) $(wildcard conio/*.asm)
OFILES = $(CFILES:.c=.o) $(AFILES:.asm=.o)
CFILES_8080= 
OFILES_8080 = $(CFILES:.c=.o) $(CFILES_8080:.c=.o)  $(AFILES_8080:.asm=.o)
OFILES_GBZ80 = $(CFILES:.c=.o) $(CFILES_8080:.c=.o)  $(AFILES_GBZ80:.asm=.o)


all: dirs $(addprefix  obj/,$(OFILES)) $(addprefix obj/ixiy/,$(OFILES)) $(addprefix obj/net/,$(ZSFILES:.c=.o)) $(addprefix obj/binary/,$(OFILES)) $(addprefix obj/stdesc/,$(OFILES)) $(addprefix obj/r2k/,$(OFILES)) $(addprefix obj/8080/,$(OFILES_8080)) $(addprefix obj/gbz80/,$(OFILES_GBZ80))

obj/net/%.o: %.asm
	$(ZCC) +z88 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/net/%.o: %.c
	$(ZCC) +z88 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -c -o $@ $^

obj/binary/%.o: %.asm
	$(ZCC) +cpm $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/binary/%.o: %.c
	$(ZCC) +cpm $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -c -o $@ $^



obj/8080/%.o: %.asm
	$(ZCC) +cpm -clib=8080 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/8080/%.o: %.c
	$(ZCC) +cpm -clib=8080 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -DCPU_8080 -c -o $@ $^

obj/gbz80/%.o: %.asm
	$(ZCC) +test -mgbz80 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/gbz80/%.o: %.c
	$(ZCC) +test -mgbz80 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -DCPU_8080 -c -o $@ $^

obj/%.o: %.asm
	$(ZCC) +test $(CFLAGS) -Ca-I../ -c -o $@ $^

obj/%.o: %.c
	$(ZCC) +test $(CFLAGS) -c -o $@ $^

obj/stdesc/%.o: %.asm
	$(ZCC) +test $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Ca-I../ -Cc-standard-escape-chars -c -o $@ $^

obj/stdesc/%.o: %.c
	$(ZCC) +test $(CFLAGS) -Cc-standard-escape-chars -c -o $@ $^




.PHONY: dirs
dirs:
	@mkdir -p obj obj/net obj/conio obj/net/zsock 
	@mkdir -p obj/ixiy obj/ixiy/conio 
	@mkdir -p obj/binary obj/binary/conio 
	@mkdir -p obj/stdesc obj/stdesc/conio  
	@mkdir -p obj/r2k obj/r2k/conio 
	@mkdir -p obj/8080 obj/8080/8080 obj/8080/conio/
	@mkdir -p obj/binary-8080 obj/binary-8080/8080 obj/binary-8080/conio 
	@mkdir -p obj/gbz80  obj/gbz80/8080  obj/gbz80/conio



ansi-clean:
	$(RM) ansi/*.o ansi/*/*.o

clean:  ansi-clean
	$(RM) *.o* *.sym *.map zcc_opt.def *.i */*.o
	$(RM) -fr obj zcc_opt.def
	$(MAKE) -C zsock clean
