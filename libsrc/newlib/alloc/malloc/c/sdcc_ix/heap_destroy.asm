
; void *heap_destroy(void *heap)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_destroy

EXTERN _mtx_destroy

defc _heap_destroy = _mtx_destroy
