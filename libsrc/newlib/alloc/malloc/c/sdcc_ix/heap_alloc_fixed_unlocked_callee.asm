
; void *heap_alloc_fixed_unlocked_callee(void *heap, void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_alloc_fixed_unlocked_callee

EXTERN asm_heap_alloc_fixed_unlocked

_heap_alloc_fixed_unlocked_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_heap_alloc_fixed_unlocked
