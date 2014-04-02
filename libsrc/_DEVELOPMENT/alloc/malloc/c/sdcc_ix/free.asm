
; void free(void *p)

XDEF _free

_free:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/malloc/z80/asm_free.asm"
