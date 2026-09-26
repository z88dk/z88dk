
; ravn/llvm-z80 compiler-rt 8-bit unsigned division/remainder helpers.
;
; At -Os/-Oz the backend calls __udivqi3/__umodqi3 instead of inlining the 8-bit
; divide (selectUDivMod8, hasOptSize); signed divide lowers to negate + these.
; Bridges adapt clang's ABI to z88dk's core l_fast_divu_8_8x8.
;
;   llvm-z80 ABI : enter A=dividend, L=divisor; exit A=quotient/remainder
;   core ABI     : enter L=dividend, E=divisor; exit L=quotient, E=remainder

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_l_clang

PUBLIC ___udivqi3
PUBLIC ___umodqi3

EXTERN l_fast_divu_8_8x8

___udivqi3:
   ld e,l                       ; E = divisor for the z88dk core
   ld l,a                       ; L = dividend for the z88dk core
   call l_fast_divu_8_8x8       ; L = quotient, E = remainder
   ld a,l                       ; A = quotient
   ret

___umodqi3:
   ld e,l                       ; E = divisor for the z88dk core
   ld l,a                       ; L = dividend for the z88dk core
   call l_fast_divu_8_8x8       ; E = remainder
   ld a,e                       ; A = remainder
   ret
