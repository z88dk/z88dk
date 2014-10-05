
; char *itoa(int num, char *buf, int radix)

SECTION seg_code_stdlib

PUBLIC _itoa

_itoa:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   push ix
   
   call asm_itoa
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm_itoa.asm"
