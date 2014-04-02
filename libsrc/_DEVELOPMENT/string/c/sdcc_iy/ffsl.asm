
; int ffsl(long i)

XDEF _ffsl

_ffsl:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_ffsl.asm"
