
; char *ultoa(unsigned long num, char *buf, int radix)

SECTION code_stdlib

PUBLIC ultoa

EXTERN asm_ultoa

ultoa:

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   
   push de
   push hl
   push ix
   push bc
   push af
   
   jp asm_ultoa
