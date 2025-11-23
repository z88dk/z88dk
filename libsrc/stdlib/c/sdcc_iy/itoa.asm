
; char *itoa(int num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _itoa

EXTERN asm_itoa

_itoa:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_itoa
