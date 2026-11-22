include ../make.config

# The T-state model in src/common/ticks_model.c, checked against cycles measured in the
# z88dk-ticks emulator.  bench.sh needs z88dk-z80asm and z88dk-ticks on the PATH.
CPUS = z80 z80n 8080 8085 vm1 gbz80 z180 kc160 r2ka r4k r6k ez80_z80 r800

all: model.ok

check$(EXESUFFIX): check.c ../../../src/common/ticks_model.c ../../../src/common/ticks_model.h
	$(CC) -std=gnu11 -Wall -I../../../src/common -o $@ check.c ../../../src/common/ticks_model.c

# One bench.sh per CPU, all at once: each is a few thousand assemble-and-run steps.
measured.txt: bench.sh instructions.txt $(wildcard instructions.*.txt)
	rm -f measured.*.txt
	for c in $(CPUS); do ./bench.sh $$c > measured.$$c.txt & done; wait
	cat $(foreach c,$(CPUS),measured.$(c).txt) > $@

model.ok: check$(EXESUFFIX) measured.txt known-gaps.txt
	./check$(EXESUFFIX) measured.txt known-gaps.txt
	touch $@

clean:
	$(RM) check$(EXESUFFIX) measured.txt measured.*.txt model.ok
