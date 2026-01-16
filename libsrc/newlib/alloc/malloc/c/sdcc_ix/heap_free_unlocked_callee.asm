
; void heap_free_unlocked_callee(void *heap, void *p)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_free_unlocked_callee

EXTERN asm_heap_free_unlocked

_heap_free_unlocked_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_heap_free_unlocked
