
; void *realloc_unlocked_callee(void *p, size_t size)

SECTION code_alloc_malloc

PUBLIC _realloc_unlocked_callee

_realloc_unlocked_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_realloc_unlocked.asm"
