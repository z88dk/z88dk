; __call_iy — indirect call trampoline for ravn/llvm-z80 clang.
;
; Z80 has no CALL (reg); the backend emits "call __call_iy" to call a function
; pointer held in IY. This jumps to (IY); the callee's RET returns to the
; original CALL site. Mirror of compiler-rt z80/call_iy.asm, shipped in
; z80_crt0.lib so +cpm -compiler=llvmz80 links it without compiler-rt.

SECTION code_l_clang

PUBLIC __call_iy

__call_iy:
	jp	(iy)
