

all: boot mk_boot_code _fix_perms

_fix_perms:
	chmod a+rx link_any.sh compile_any.sh

boot: boot.c
	gcc -o boot boot.c

mk_boot_code: mk_boot_code.c
	gcc -o mk_boot_code mk_boot_code.c


clean:
	rm -f *.o boot mk_boot_code
