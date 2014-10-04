
; void heap_info_unlocked(void *heap, void *callback)

SECTION seg_code_malloc

PUBLIC heap_info_unlocked

heap_info_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_heap_info_unlocked
   
   pop ix
   ret
   
   INCLUDE "alloc/malloc/z80/asm_heap_info_unlocked.asm"
