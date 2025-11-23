
; char *utoa(unsigned int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _utoa

EXTERN asm_utoa

_utoa:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_utoa
