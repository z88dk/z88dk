
; void heap_free_unlocked_callee(void *heap, void *p)

SECTION code_alloc_malloc

PUBLIC _heap_free_unlocked_callee

_heap_free_unlocked_callee:

   pop hl
   pop de
   ex (sp),hl

   INCLUDE "alloc/malloc/z80/asm_heap_free_unlocked.asm"
