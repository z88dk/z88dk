
; void heap_info_unlocked(void *heap, void *callback)

SECTION code_alloc_malloc

PUBLIC heap_info_unlocked

heap_info_unlocked:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   push bc
   ex (sp),ix
   
   call asm_heap_info_unlocked
   
   pop ix
   ret
   
   INCLUDE "alloc/malloc/z80/asm_heap_info_unlocked.asm"
