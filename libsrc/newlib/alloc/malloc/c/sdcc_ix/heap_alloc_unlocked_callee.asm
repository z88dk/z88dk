
; void *heap_alloc_unlocked_callee(void *heap, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_alloc_unlocked_callee

EXTERN asm_heap_alloc_unlocked

_heap_alloc_unlocked_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_heap_alloc_unlocked
