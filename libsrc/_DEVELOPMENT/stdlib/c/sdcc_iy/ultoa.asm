
; char *ultoa(unsigned long num, char *buf, int radix)

SECTION code_stdlib

PUBLIC _ultoa

_ultoa:

   pop af
   pop hl
   pop de
   pop ix
   pop bc
   
   push bc
   push ix
   push de
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm_ultoa.asm"
