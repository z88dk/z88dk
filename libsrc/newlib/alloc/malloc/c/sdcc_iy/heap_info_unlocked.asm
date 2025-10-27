
; void heap_info_unlocked(void *heap, void *callback)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_info_unlocked

EXTERN asm_heap_info_unlocked

heap_info_unlocked:

   pop af
   pop de
   pop ix
   
   push hl
   push de
   push af
   
   jp asm_heap_info_unlocked
