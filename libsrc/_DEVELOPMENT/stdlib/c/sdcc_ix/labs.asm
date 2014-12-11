
; long labs(long j)

SECTION code_stdlib

PUBLIC _labs

_labs:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm_labs.asm"
