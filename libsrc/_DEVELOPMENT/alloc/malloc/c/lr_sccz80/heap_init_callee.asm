
; void *heap_init(void *heap, size_t size)

XDEF heap_init_callee

heap_init_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_heap_init.asm"
