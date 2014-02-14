
; long labs(long j)

XDEF labs

labs:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_labs.asm"
