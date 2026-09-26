; NEWLIB copy of ../__divhi3.asm (identical body; no config_private.inc needed).
; Built into llvmz80_imath.lib, pulled on demand by -clib=newlib_ix/newlib_iy;
; the l_*_16_16x16 cores are bundled in the newlib archive. Keep in sync with
; the parent if the clang HImode ABI changes.
;
; compiler-rt-named 16-bit integer helpers for ravn/llvm-z80 clang.
;
; The backend emits libgcc/compiler-rt names for the 16-bit integer ops it
; can't inline (__divhi3/__modhi3/__udivhi3/__umodhi3/__mulhi3, hard-coded in
; Z80InstructionSelector.cpp). z88dk's l/clang shipped SDCC-style names instead,
; so none resolved. These wrappers export the names clang actually calls.
;
; clang ABI (sdcccall(1)): arg1=HL, arg2=DE; RETURN in DE (not HL); HL/DE/BC/AF
; caller-saved, IX/IY reserved. The z88dk cores take (HL,DE) but return the
; primary result in HL:
;   l_divs_16_16x16 / l_divu_16_16x16 : hl=quotient, de=remainder
;   l_mulu_16_16x16 : hl=product (low 16, sign-agnostic -> serves __mulhi3)
; So quotient/product wrappers do `ex de,hl`; modulo wrappers tail-call.

SECTION code_l_clang

PUBLIC ___divhi3
PUBLIC ___udivhi3
PUBLIC ___mulhi3
PUBLIC ___umulhi3
PUBLIC ___modhi3
PUBLIC ___umodhi3

; -Os/-Oz emits the plain names above; any non-size opt level (zcc maps every
; non-`--opt-code-size` build to clang `-O3`, see src/zcc/zcc.c) makes the
; backend rename the div/mod libcalls to the "_fast" repeated-subtraction
; variants (selectDivModRuntimeName in Z80InstructionSelector.cpp).  The ABI is
; identical -- only the symbol name changes -- so the _fast entries are plain
; aliases of the cores below (z88dk has no bounded fast core; the shared
; l_div[su]_16_16x16 gives the same result).  Mul has no _fast variant.
PUBLIC ___divhi3_fast
PUBLIC ___udivhi3_fast
PUBLIC ___modhi3_fast
PUBLIC ___umodhi3_fast

EXTERN l_divs_16_16x16
EXTERN l_divu_16_16x16
EXTERN l_mulu_16_16x16

; int __divhi3(int a, int b)  ->  a / b  (signed), result in DE
___divhi3:
___divhi3_fast:
   call l_divs_16_16x16     ; hl = quotient, de = remainder
   ex de,hl                 ; DE = quotient (clang's return register)
   ret

; unsigned __udivhi3(unsigned a, unsigned b)  ->  a / b, result in DE
___udivhi3:
___udivhi3_fast:
   call l_divu_16_16x16     ; hl = quotient, de = remainder
   ex de,hl                 ; DE = quotient
   ret

; int __mulhi3(int a, int b)  ->  a * b  (low 16 bits), result in DE
; unsigned __umulhi3 aliases it: the low 16 bits of a product are sign-agnostic.
___mulhi3:
___umulhi3:
   call l_mulu_16_16x16     ; hl = product
   ex de,hl                 ; DE = product
   ret

; int __modhi3(int a, int b)  ->  a % b  (signed), result in DE
___modhi3:
___modhi3_fast:
   jp l_divs_16_16x16       ; de = remainder already -> tail-call

; unsigned __umodhi3(unsigned a, unsigned b)  ->  a % b, result in DE
___umodhi3:
___umodhi3_fast:
   jp l_divu_16_16x16       ; de = remainder already -> tail-call
