
; int atoi(const char *buf)

SECTION code_stdlib

PUBLIC _atoi

_atoi:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdlib/z80/asm_atoi.asm"
