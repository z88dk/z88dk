
; void heap_info_unlocked(void *heap, void *callback)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_info_unlocked_callee

EXTERN asm_heap_info_unlocked

heap_info_unlocked_callee:

   pop af
   pop hl
   pop de
   push af

   push ix
   push hl
   pop ix

   call asm_heap_info_unlocked
   pop ix
   ret
