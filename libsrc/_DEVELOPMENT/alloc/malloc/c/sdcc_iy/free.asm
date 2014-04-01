
; void free(void *p)

XDEF free

free:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/malloc/z80/asm_free.asm"
