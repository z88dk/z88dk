
; char *ltoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ltoa

EXTERN l0_ltoa_callee

_ltoa:

   pop af
   pop hl
   pop de
   exx
   pop bc
   exx
   pop bc
   
   push bc
   push bc
   push de
   push hl
   push af

   jp l0_ltoa_callee
