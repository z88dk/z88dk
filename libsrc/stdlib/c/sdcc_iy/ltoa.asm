
; char *ltoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ltoa

EXTERN asm_ltoa

_ltoa:

   pop af
   pop hl
   pop de
   pop ix
   pop bc
   
   push bc
   push hl
   push de
   push hl
   push af
   
   jp asm_ltoa
