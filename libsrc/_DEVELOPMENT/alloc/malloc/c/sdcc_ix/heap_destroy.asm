
; void *heap_destroy(void *heap)

SECTION seg_code_malloc

PUBLIC _heap_destroy

EXTERN _mtx_destroy

defc _heap_destroy = _mtx_destroy

INCLUDE "alloc/malloc/z80/asm_heap_destroy.asm"
