
; void balloc_free(void *m)

XDEF _balloc_free

_balloc_free:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/balloc/z80/asm_balloc_free.asm"
