
; void *balloc_alloc_fastcall(unsigned int queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_alloc_fastcall

EXTERN asm_balloc_alloc

defc _balloc_alloc_fastcall = asm_balloc_alloc
