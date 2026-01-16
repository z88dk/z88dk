
SECTION code_clib
SECTION code_l_sdcc

PUBLIC __mulint_callee

EXTERN l_mulu_16_16x16

__mulint_callee:

   ; 16-bit multiplication, LSW 16-bit result
   ;
   ; enter : stack = multiplicand, multiplicand, ret
   ;
   ; exit  : hl = product
   
   pop af
   pop hl
   pop de
   push af
   
   jp l_mulu_16_16x16
