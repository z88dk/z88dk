
; void heap_free_unlocked(void *heap, void *p)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_free_unlocked

EXTERN asm_heap_free_unlocked

heap_free_unlocked:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_heap_free_unlocked
