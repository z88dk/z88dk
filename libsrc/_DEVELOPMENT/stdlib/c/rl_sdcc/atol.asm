
; long atol(const char *buf)

XDEF atol

atol:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   INCLUDE "stdlib/z80/asm_atol.asm"
