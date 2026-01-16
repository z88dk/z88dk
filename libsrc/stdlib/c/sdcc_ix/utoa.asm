
; char *utoa(unsigned int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _utoa

EXTERN l0_utoa_callee

_utoa:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_utoa_callee
