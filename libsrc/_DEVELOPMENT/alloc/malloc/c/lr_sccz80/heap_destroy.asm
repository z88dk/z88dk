
; void *heap_destroy(void *heap)

XDEF heap_destroy

defc heap_destroy = asm_heap_destroy

INCLUDE "../../z80/asm_heap_destroy.asm"
