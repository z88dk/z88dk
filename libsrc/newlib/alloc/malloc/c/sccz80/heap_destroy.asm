
; void *heap_destroy(void *heap)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC heap_destroy

EXTERN asm_heap_destroy

defc heap_destroy = asm_heap_destroy
