
; void *malloc(size_t size)

XDEF malloc

malloc:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_malloc.asm"
