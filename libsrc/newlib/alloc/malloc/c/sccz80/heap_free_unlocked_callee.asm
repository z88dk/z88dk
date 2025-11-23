
; void heap_free_unlocked_callee(void *heap, void *p)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_free_unlocked_callee

EXTERN asm_heap_free_unlocked

heap_free_unlocked_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_heap_free_unlocked
