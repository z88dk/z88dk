
; void *_falloc__unlocked(void *p, size_t size)

SECTION code_alloc_malloc

PUBLIC __falloc__unlocked

__falloc__unlocked:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm__falloc_unlocked.asm"
