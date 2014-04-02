
; void *realloc_unlocked(void *p, size_t size)

XDEF _realloc_unlocked

_realloc_unlocked:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_realloc_unlocked.asm"
