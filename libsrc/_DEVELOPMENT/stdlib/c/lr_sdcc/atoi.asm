
; int atoi(const char *buf)

XDEF atoi

atoi:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdlib/z80/asm_atoi.asm"
