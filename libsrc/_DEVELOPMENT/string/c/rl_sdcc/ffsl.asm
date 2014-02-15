
; int ffsl(long i)

XDEF ffsl

ffsl:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_ffsl.asm"
