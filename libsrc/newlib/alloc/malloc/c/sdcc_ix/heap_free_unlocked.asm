
; void heap_free_unlocked(void *heap, void *p)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_free_unlocked

EXTERN asm_heap_free_unlocked

_heap_free_unlocked:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_heap_free_unlocked
