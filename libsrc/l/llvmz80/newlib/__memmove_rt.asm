
; ravn/llvm-z80 compiler-rt runtime-direction memmove helper -- newlib copy.
;
; Self-contained sibling of libsrc/l/llvmz80/__memmove_rt.asm for the z88dk
; newlib target driven by -compiler=llvmz80 (-clib=newlib_ix / newlib_iy),
; bundled into llvmz80_imath.lib.  Same idiom as the neighboring integer-math
; adapters: a thin bridge that calls a core ALREADY reachable in the link
; (here z88dk's overlap-safe asm_memmove), with NO classic-clib build context
; (no `INCLUDE config_private.inc`).
;
; The backend cannot always prove the copy direction between two pointers at
; compile time; in that case Z80LegalizerInfo.cpp lowers llvm.memmove to this
; internal helper under the Z80_AllReg calling convention (register args only,
; nothing callee-saved -- ravn/llvm-z80#126) instead of the full memmove
; stack-ABI call.  clang passes dst=HL, src=DE, size=BC (Z80_AllReg order);
; z88dk's asm_memmove core takes hl=src, de=dst, bc=n (already overlap-safe:
; picks LDIR/LDDR by comparing dst vs src) and returns void-for-our-purposes.
; clang's HL/DE (dst/src) is the swap of the core's HL/DE (src/dst), so one
; `ex de,hl` before the tail call converts the arguments.

SECTION code_clib

; clang's datalayout prefixes every symbol with an extra leading `_`, so the
; assembly-visible symbol is ___memmove_rt (three underscores) -- mirrors
; ___mulsi3/___divsi3 in the sibling bridges.
PUBLIC ___memmove_rt

EXTERN asm_memmove

___memmove_rt:
   ex de,hl                     ; llvm-z80 dst=HL,src=DE -> core src=HL,dst=DE
   jp asm_memmove               ; tail call; core's return values are unused (void)
