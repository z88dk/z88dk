
; long atol(const char *buf)

SECTION code_stdlib

PUBLIC _atol

_atol:

   pop af
   pop hl

   push hl
   push af

   INCLUDE "stdlib/z80/asm_atol.asm"
