
; void *balloc_alloc(unsigned int queue)

XDEF balloc_alloc

balloc_alloc:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_balloc_alloc.asm"
