
; void heap_info_unlocked(void *heap, void *callback)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_info_unlocked_callee

EXTERN asm_heap_info_unlocked

heap_info_unlocked_callee:

   pop af
   pop ix
   pop de
   push af
   
   jp asm_heap_info_unlocked
