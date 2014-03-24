
; void balloc_free(void *m)

XDEF balloc_free

balloc_free:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/balloc/z80/asm_balloc_free.asm"
