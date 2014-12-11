
; void *malloc_unlocked(size_t size)

SECTION code_alloc_malloc

PUBLIC _malloc_unlocked

_malloc_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "alloc/malloc/z80/asm_malloc_unlocked.asm"
