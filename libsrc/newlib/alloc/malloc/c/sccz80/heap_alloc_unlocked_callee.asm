
; void *heap_alloc_unlocked(void *heap, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_alloc_unlocked_callee

EXTERN asm_heap_alloc_unlocked

heap_alloc_unlocked_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_heap_alloc_unlocked
