
; void heap_info_unlocked(void *heap, void *callback)

PUBLIC heap_info_unlocked_callee

heap_info_unlocked_callee:

   pop af
   pop ix
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_info_unlocked.asm"
