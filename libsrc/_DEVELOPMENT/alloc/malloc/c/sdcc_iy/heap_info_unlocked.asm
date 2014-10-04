
; void heap_info_unlocked(void *heap, void *callback)

SECTION seg_code_malloc

PUBLIC heap_info_unlocked

heap_info_unlocked:

   pop af
   pop de
   pop ix
   
   push ix
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_info_unlocked.asm"
