
; void *calloc_unlocked_callee(size_t nmemb, size_t size)

SECTION code_alloc_malloc

PUBLIC _calloc_unlocked_callee

_calloc_unlocked_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_calloc_unlocked.asm"
