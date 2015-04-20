
; void *_falloc__unlocked_callee(void *p, size_t size)

SECTION code_alloc_malloc

PUBLIC __falloc__unlocked_callee

__falloc__unlocked_callee:

   pop af
   pop bc
   pop hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm__falloc_unlocked.asm"
