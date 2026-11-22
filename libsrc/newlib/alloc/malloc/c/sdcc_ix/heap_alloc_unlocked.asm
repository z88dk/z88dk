
; void *heap_alloc_unlocked(void *heap, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_alloc_unlocked

EXTERN asm_heap_alloc_unlocked

_heap_alloc_unlocked:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_heap_alloc_unlocked
