
; void *realloc_unlocked(void *p, size_t size)

XDEF realloc_unlocked

realloc_unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_realloc_unlocked.asm"
