include ../../../Make.config

CFILES = \
	_putoffset.c \
	bios.c \
	bdos.c \
	bdos_callee.c \
	bdosh.c \
	bdosh_callee.c \
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
        fsync.c \
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
OBJECTS = $(addprefix obj/z80/nodevice/,$(OFILES)) $(addprefix obj/z80/device/,$(OFILES)) \
	$(addprefix obj/8080/nodevice/,$(OFILES)) $(addprefix obj/8080/device/,$(OFILES)) \
	$(addprefix obj/ixiy/nodevice/,$(OFILES)) $(addprefix obj/ixiy/device/,$(OFILES)) \
	$(addprefix obj/z180/nodevice/,$(OFILES)) $(addprefix obj/z180/device/,$(OFILES))


all: dirs $(OBJECTS)

obj/z80/nodevice/%.o: %.c
	$(ZCC) +cpm $(CFLAGS) $^ -o $@

obj/z80/device/%.o: %.c
	$(ZCC) +cpm $(CFLAGS) -DDEVICES $^ -o $@

obj/z180/nodevice/%.o: %.c
	$(ZCC) +cpm -clib=z180 $(CFLAGS) $^ -o $@

obj/z180/device/%.o: %.c
	$(ZCC) +cpm -clib=z180 $(CFLAGS) -DDEVICES $^ -o $@

obj/8080/nodevice/%.o: %.c
	$(ZCC) +cpm -clib=8080 $(CFLAGS) $^ -o $@

obj/8080/device/%.o: %.c
	$(ZCC) +cpm -clib=8080 $(CFLAGS) -DDEVICES $^ -o $@

obj/ixiy/nodevice/%.o: %.c
	$(ZCC) +cpm -clib=ixiy $(CFLAGS) $^ -o $@

obj/ixiy/device/%.o: %.c
	$(ZCC) +cpm -clib=ixiy $(CFLAGS) -DDEVICES $^ -o $@


.PHONY:	dirs

dirs:
	@mkdir -p obj obj/z80/device obj/z80/nodevice obj/8080/device obj/8080/nodevice  obj/ixiy/device obj/ixiy/nodevice obj/z180/nodevice obj/z180/device

clean:
	$(RM) -fr obj zcc_opt.def
