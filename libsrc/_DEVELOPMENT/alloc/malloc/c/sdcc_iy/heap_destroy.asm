
; void *heap_destroy(void *heap)

XDEF heap_destroy

LIB mtx_destroy

heap_destroy:

   jp mtx_destroy

   INCLUDE "alloc/malloc/z80/asm_heap_destroy.asm"
