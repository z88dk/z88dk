
; void *heap_calloc_unlocked(void *heap, size_t nmemb, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_calloc_unlocked

EXTERN asm_heap_calloc_unlocked

heap_calloc_unlocked:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_heap_calloc_unlocked
