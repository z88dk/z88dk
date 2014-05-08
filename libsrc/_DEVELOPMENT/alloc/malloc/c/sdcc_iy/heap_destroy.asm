
; void *heap_destroy(void *heap)

PUBLIC _heap_destroy

EXTERN _mtx_destroy

_heap_destroy:

   jp _mtx_destroy

   INCLUDE "alloc/malloc/z80/asm_heap_destroy.asm"
