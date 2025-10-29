
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ___muluint2ulong_callee

EXTERN l_mulu_32_16x16

___muluint2ulong_callee:

   ; 16-bit multiplication, 32-bit result
   ;
   ; enter : stack = multiplicand, multiplicand, ret
   ;
   ; exit  : dehl = product

   pop af
   pop hl
   pop de
   push af

   jp l_mulu_32_16x16
