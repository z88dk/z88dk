include ../make.config

# The +test CRT is at address 0 and owns rst 28h.
# The archive window is 4000h-7FFFh, so this image is linked at 8000h.
# ticks -w exits 1 after a normal -end, so this recipe does not use -w.

ROOT := ../../..
INC := -Ilib/target/ti83p/def -Ilibsrc
OBJ := obj/libsrc/target/ticalc/fcntl

all: test_arch_span

test_arch_span: arch_span.asm
	cd $(ROOT) && z88dk-z80asm -mz80 -DFORti83p $(INC) \
		-Otest/suites/ticalc/obj \
		libsrc/target/ticalc/fcntl/ti_geom.asm \
		libsrc/target/ticalc/fcntl/ti_arch.asm \
		libsrc/target/ticalc/fcntl/ti_slot.asm \
		libsrc/target/ticalc/fcntl/ti_files.asm
	z88dk-z80asm -mz80 -DFORti83p -I$(ROOT)/lib/target/ti83p/def -I$(ROOT)/libsrc \
		-b -m -s -r0x8000 -oarch_span.bin arch_span.asm \
		$(OBJ)/ti_geom.o $(OBJ)/ti_arch.o $(OBJ)/ti_slot.o $(OBJ)/ti_files.o
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting ticalc arch_span $(RESET)"
	@out=$$(z88dk-ticks -mz80 -iochar 1 -x arch_span.map -end pass -l 0x8000 arch_span.bin 2>&1); \
	ec=$$?; printf '%s\n' "$$out"; \
	ok=0; \
	case "$$out" in *arch-ok*) ok=1 ;; esac; \
	case "$$out" in *arch-no*) ok=0 ;; esac; \
	case "$$out" in *"counter limit"*) ok=0 ;; esac; \
	test $$ec -eq 0 && test $$ok -eq 1 \
		|| { echo "$(RED)" `date +%H:%M:%S` " ticalc arch_span failure $(RESET)"; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " ticalc arch_span completed $(RESET)"

clean:
	rm -rf obj
	rm -f arch_span.bin arch_span.map arch_span.sym arch_span.o

.PHONY: all test_arch_span clean
