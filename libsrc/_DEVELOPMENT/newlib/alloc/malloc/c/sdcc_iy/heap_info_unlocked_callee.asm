
; void heap_info_unlocked_callee(void *heap, void *callback)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_info_unlocked_callee

EXTERN asm_heap_info_unlocked

_heap_info_unlocked_callee:

   pop af
   pop de
   pop ix
   push af

   jp asm_heap_info_unlocked
