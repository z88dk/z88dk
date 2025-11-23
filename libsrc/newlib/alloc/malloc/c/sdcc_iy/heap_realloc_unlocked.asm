
; void *heap_realloc_unlocked(void *heap, void *p, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_realloc_unlocked

EXTERN asm_heap_realloc_unlocked

_heap_realloc_unlocked:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   jp asm_heap_realloc_unlocked
