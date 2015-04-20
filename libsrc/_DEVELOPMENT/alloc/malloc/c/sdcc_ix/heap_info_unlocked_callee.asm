
; void heap_info_unlocked_callee(void *heap, void *callback)

SECTION code_alloc_malloc

PUBLIC _heap_info_unlocked_callee, l0_heap_info_unlocked_callee

_heap_info_unlocked_callee:

   pop af
   pop de
   pop bc
   push af

l0_heap_info_unlocked_callee:

   push bc
   ex (sp),ix
   
   call asm_heap_info_unlocked
   
   pop ix
   ret
   
   INCLUDE "alloc/malloc/z80/asm_heap_info_unlocked.asm"
