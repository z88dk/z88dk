; compiler-rt-named int<->f32 conversion helpers for ravn/llvm-z80 clang,
; bridged to z88dk's math32 (IEEE-754 binary32) cores. ravn/llvm-z80 #277.
;
; Same opt-in gate as __addsf3.asm (see that file's header for the full ABI
; story): only active when clang is invoked with `-mllvm -z80-float-sdcccall0`.
;
; Measured ABI (llc -S disassembly of `long f2i(float a){return (long)a;}` /
; `float i2f(int a){return (float)a;}` etc. under the flag, ravn/llvm-z80
; Z80LegalizerInfo.cpp G_FPTOSI/G_FPTOUI/G_SITOFP/G_UITOFP custom case):
;   __fixsfsi/__fixunssfsi(float):  1 stack arg (32-bit float, 2 pushes),
;     caller cleans up (2 pops after call); 32-bit int result in DE:HL
;     (D=MSB) -- clang widens the eventual 16-bit `int` result via a plain
;     truncate that keeps the low word (HL), so the libcall itself always
;     produces a full 32-bit DE:HL result regardless of the C-level target
;     width.
;   __floatsisf/__floatunsisf(int): clang SIGN/ZERO-EXTENDS the 16-bit `int`
;     argument to 32-bit *before* the call (minScalar legalization rule), so
;     this libcall always receives a full 32-bit stack argument (2 pushes),
;     caller cleans up; 32-bit float result in DE:HL (D=MSB).
;
; z88dk math32 bridge selection -- NOT the 16-bit-int cm32_sdcc___sint2fs/
; ___uint2fs wrappers (those read only a single 16-bit stack word, which
; would silently drop half of clang's 32-bit argument): the 32-bit
; cm32_sdcc___slong2fs/___ulong2fs wrappers match instead, confirmed by
; reading libsrc/math/float/math32/c/sdcc/cm32_sdcc___slong2fs.asm: entry
; stack = 32-bit value + ret (peeked non-destructively, caller-cleanup),
; `jp m32_float32`/`m32_float32u`, DE:HL result -- an exact match.
;
; For the float->int direction, cm32_sdcc___fs2sint/___fs2uint already alias
; the SAME core routine as cm32_sdcc___fs2slong/___fs2ulong (m32_f2sint,
; m32_f2uint, m32_f2slong and m32_f2ulong are literally the same code label
; in libsrc/math/float/math32/asm/z80/f32_f2long.asm), so either name works;
; ___fs2sint/___fs2uint are used here for the closer name match to
; __fixsfsi/__fixunssfsi. Confirmed: entry reads the 32-bit float stack arg
; via cm32_sdcc_fsread1 (non-destructive, caller-cleanup), produces a full
; DE:HL 32-bit int result -- exactly the ABI clang expects.
;
; All four are therefore PURE ALIASES, same style as __addsf3.asm. Verified
; end-to-end at runtime under ntvcm (boundary values incl. 0, negative,
; INT16_MIN/MAX) -- see z88dk/test/clang/runtime_fconv.c + runtime_fconv.sh.

SECTION code_l_clang

PUBLIC ___fixsfsi
PUBLIC ___fixunssfsi
PUBLIC ___floatsisf
PUBLIC ___floatunsisf

EXTERN cm32_sdcc___fs2sint
EXTERN cm32_sdcc___fs2uint
EXTERN cm32_sdcc___slong2fs
EXTERN cm32_sdcc___ulong2fs

___fixsfsi:     jp cm32_sdcc___fs2sint
___fixunssfsi:  jp cm32_sdcc___fs2uint
___floatsisf:   jp cm32_sdcc___slong2fs
___floatunsisf: jp cm32_sdcc___ulong2fs
