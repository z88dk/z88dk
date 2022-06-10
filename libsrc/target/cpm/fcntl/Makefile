include ../../../Make.config

CFILES = \
	_putoffset.c \
	bios.c \
	bdos.c \
	cache.c \
	close.c \
	creat.c \
	change_volume.c \
	dir_move_first.c \
	dir_move_next.c \
	dir_get_entry_type.c \
	dir_get_entry_name.c \
	dir_get_entry_size.c \
	execv.c \
	get_current_volume.c \
	get_dpb.c \
	get_dir_name.c \
	fdtell.c \
	fdgetpos.c \
	getfcb.c \
	lseek.c \
	open.c \
	parsefcb.c \
	read.c \
	readbyte.c \
	remove.c \
	rename.c \
	setfcb.c \
	stat.c \
	swapuid.c \
	write.c \
	writebyte.c 

AFILES = $(CFILES:.c=.asm)
OFILES = $(CFILES:.c=.o)
OBJECTS = $(addprefix obj/z80/nodevice/,$(OFILES)) $(addprefix obj/z80/device/,$(OFILES)) $(addprefix obj/8080/nodevice/,$(OFILES)) $(addprefix obj/8080/device/,$(OFILES))


all: dirs $(OBJECTS)

obj/z80/nodevice/%.o: %.c
	$(ZCC) +cpm $(CFLAGS) $^ -o $@

obj/z80/device/%.o: %.c
	$(ZCC) +cpm $(CFLAGS) -DDEVICES $^ -o $@

obj/8080/nodevice/%.o: %.c
	$(ZCC) +cpm -clib=8080 $(CFLAGS) $^ -o $@

obj/8080/device/%.o: %.c
	$(ZCC) +cpm -clib=8080 $(CFLAGS) -DDEVICES $^ -o $@


.PHONY:	dirs

dirs:
	@mkdir -p obj obj/z80/device obj/z80/nodevice obj/8080/device obj/8080/nodevice

clean:
	$(RM) -fr obj zcc_opt.def
