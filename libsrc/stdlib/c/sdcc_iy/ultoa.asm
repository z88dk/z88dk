
; char *ultoa(unsigned long num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ultoa

EXTERN asm_ultoa

_ultoa:

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
   
   jp asm_ultoa
