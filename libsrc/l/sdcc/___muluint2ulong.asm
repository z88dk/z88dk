
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ___muluint2ulong

EXTERN l_mulu_32_16x16

___muluint2ulong:

   ; 16-bit multiplication, 32-bit result
   ;
   ; enter : stack = multiplicand, multiplicand, ret
   ;
   ; exit  : dehl = product

   pop af
   pop hl
   pop de

   push de
   push hl
   push af

   jp l_mulu_32_16x16
