#

include ../Make.config

CFILES = $(wildcard *.c)
ZSFILES = $(wildcard zsock/*.c) 
AFILES = $(wildcard *.asm)
AFILES_8080 = $(filter-out $(wildcard *scanf*.asm), $(wildcard *.asm))
OFILES = $(CFILES:.c=.o) $(AFILES:.asm=.o)
CFILES_8080= 
OFILES_8080 = $(CFILES:.c=.o) $(CFILES_8080:.c=.o)  $(AFILES_8080:.asm=.o)


all: dirs $(addprefix  obj/,$(OFILES)) $(addprefix obj/ixiy/,$(OFILES)) $(addprefix obj/net/,$(ZSFILES:.c=.o)) $(addprefix obj/binary/,$(OFILES)) $(addprefix obj/stdesc/,$(OFILES)) $(addprefix obj/r2k/,$(OFILES)) $(addprefix obj/8080/,$(OFILES_8080))

obj/net/%.o: %.asm
	$(ZCC) +z88 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/net/%.o: %.c
	$(ZCC) +z88 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -c -o $@ $^

obj/binary/%.o: %.asm
	$(ZCC) +cpm $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/binary/%.o: %.c
	$(ZCC) +cpm $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -c -o $@ $^



obj/8080/%.o: %.asm
	$(ZCC) +cpm -m8080 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -Ca-I../ -c -o $@ $^

obj/8080/%.o: %.c
	$(ZCC) +cpm -m8080 $(CFLAGS) -Ca-DSTANDARDESCAPECHARS -Cc-standard-escape-chars -DCPU_8080 -c -o $@ $^

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
	@mkdir -p obj obj/net obj/net/zsock obj/ixiy obj/binary obj/stdesc obj/r2k obj/8080 obj/8080/8080 obj/binary-8080 obj/binary-8080/8080



ansi-clean:
	$(RM) ansi/*.o ansi/*/*.o

clean:  ansi-clean
	$(RM) *.o* *.sym *.map zcc_opt.def *.i */*.o
	$(RM) -fr obj zcc_opt.def
	$(MAKE) -C zsock clean
