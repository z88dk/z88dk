
; void balloc_free_fastcall(void *m)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_free_fastcall

EXTERN asm_balloc_free

defc _balloc_free_fastcall = asm_balloc_free
