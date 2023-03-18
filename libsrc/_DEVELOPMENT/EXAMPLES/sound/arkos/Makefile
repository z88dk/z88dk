.SILENT:

TARGETS := zx zxn

CLIBS := new sdcc_ix sdcc_iy

all: periodic-targets interrupt-targets

periodic-targets:
	for target in $(TARGETS); do \
		for clib in $(CLIBS); do \
			echo "Compiling arkos_periodic.c for $$target-$$clib..." ; \
			zcc +$$target -vn -clib=$$clib arkos_periodic.c -o ark-$$target-$$clib -create-app ; \
		done \
	done

interrupt-targets:
	for target in $(TARGETS); do \
		for clib in $(CLIBS); do \
			echo "Compiling arkos_interrupt.c for $$target-$$clib..." ; \
			zcc +$$target -vn -clib=$$clib arkos_interrupt.c -o ark-$$target-$$clib -create-app ;\
		done \
	done

clean:
	@-rm ark-* *.bin *.tap 2>/dev/null
	
