
; void *malloc_unlocked(size_t size)

XDEF malloc_unlocked

malloc_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_malloc_unlocked.asm"
