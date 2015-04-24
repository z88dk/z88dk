
; void *heap_alloc_fixed_unlocked_callee(void *heap, void *p, size_t size)

SECTION code_alloc_malloc

PUBLIC _heap_alloc_fixed_unlocked_callee

_heap_alloc_fixed_unlocked_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_fixed_unlocked.asm"
