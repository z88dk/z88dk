
; void heap_info_unlocked_callee(void *heap, void *callback)

SECTION code_alloc_malloc

PUBLIC _heap_info_unlocked_callee

_heap_info_unlocked_callee:

   pop af
   pop de
   pop ix
   push af

   INCLUDE "alloc/malloc/z80/asm_heap_info_unlocked.asm"
