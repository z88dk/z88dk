
; void *_falloc__unlocked(void *p, size_t size)

SECTION code_alloc_malloc

PUBLIC _falloc__unlocked_callee

_falloc__unlocked_callee:

   pop af
   pop hl
   pop bc
   push af

   INCLUDE "alloc/malloc/z80/asm__falloc_unlocked.asm"
