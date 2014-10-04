
; void *heap_init(void *heap, size_t size)

SECTION seg_code_malloc

PUBLIC heap_init_callee

heap_init_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/malloc/z80/asm_heap_init.asm"
