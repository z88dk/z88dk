
; NEWLIB copy of ../__udivqi3.asm, minus the `INCLUDE "config_private.inc"`
; (absent on the newlib cpm target). Built into llvmz80_imath.lib.
;
; ravn/llvm-z80 compiler-rt 8-bit unsigned division/remainder helpers.
;
; At -Os/-Oz the backend calls __udivqi3/__umodqi3 instead of inlining the 8-bit
; divide (selectUDivMod8, hasOptSize); signed divide lowers to negate + these.
; Bridges adapt clang's ABI to the newlib core l_fast_divu_8_8x8.
;
;   llvm-z80 ABI : enter A=dividend, E=divisor; exit A=quotient/remainder
;   core ABI     : enter L=dividend, E=divisor; exit L=quotient, E=remainder


SECTION code_clib
SECTION code_l_clang

PUBLIC ___udivqi3
PUBLIC ___umodqi3

EXTERN l_fast_divu_8_8x8

___udivqi3:
   ld l,a                       ; L = dividend (E already = divisor)
   call l_fast_divu_8_8x8       ; L = quotient, E = remainder
   ld a,l                       ; A = quotient
   ret

___umodqi3:
   ld l,a                       ; L = dividend
   call l_fast_divu_8_8x8       ; E = remainder
   ld a,e                       ; A = remainder
   ret
