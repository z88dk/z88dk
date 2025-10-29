
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __moduint

EXTERN l_divu_16_16x16

__moduint:

   ; unsigned 16-bit mod
   ;
   ; enter : stack = divisor, dividend, ret
   ;
   ; exit  : hl = remainder
   ;         de = divisor
   
   pop af
   pop hl                      ; hl = dividend
   pop de                      ; de = remainder
   
   push de
   push hl
   push af

   call l_divu_16_16x16
   
   ex de,hl
   ret
