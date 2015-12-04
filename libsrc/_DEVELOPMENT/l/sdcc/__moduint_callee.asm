
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __moduint_callee

EXTERN l_divu_16_16x16

__moduint_callee:

   ; unsigned 16-bit mod
   ;
   ; enter : stack = divisor, dividend, ret
   ;
   ; exit  : hl = remainder
   ;         de = divisor
   
   pop af
   pop hl                      ; hl = dividend
   pop de                      ; de = remainder
   push af

   call l_divu_16_16x16
   
   ex de,hl
   ret
