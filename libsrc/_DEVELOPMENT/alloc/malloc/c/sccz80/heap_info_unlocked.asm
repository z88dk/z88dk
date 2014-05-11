
; void heap_info_unlocked(void *heap, void *callback)

PUBLIC heap_info_unlocked

EXTERN asm_heap_info_unlocked

heap_info_unlocked:

   pop af
   pop ix
   pop de
   
   push de
   push ix
   push af
   
   jp asm_heap_info_unlocked
