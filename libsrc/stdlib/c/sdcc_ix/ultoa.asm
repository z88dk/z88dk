
; char *ultoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ultoa

EXTERN l0_ultoa_callee

_ultoa:

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

   jp l0_ultoa_callee
