
; void balloc_free(void *m)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_free

EXTERN asm_balloc_free

defc balloc_free = asm_balloc_free
