
; void heap_info_unlocked(void *heap, void *callback)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_info_unlocked

EXTERN l0_heap_info_unlocked_callee

heap_info_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp l0_heap_info_unlocked_callee
