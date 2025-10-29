
; void *heap_destroy_fastcall(void *heap)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _heap_destroy_fastcall

EXTERN _mtx_destroy_fastcall

defc _heap_destroy_fastcall = _mtx_destroy_fastcall
