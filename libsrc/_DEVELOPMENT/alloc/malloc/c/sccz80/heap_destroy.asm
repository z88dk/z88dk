
; void *heap_destroy(void *heap)

SECTION seg_code_malloc

PUBLIC heap_destroy

defc heap_destroy = asm_heap_destroy

INCLUDE "alloc/malloc/z80/asm_heap_destroy.asm"
