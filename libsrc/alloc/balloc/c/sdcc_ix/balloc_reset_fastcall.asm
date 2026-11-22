; void *balloc_reset(unsigned char queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_reset_fastcall

EXTERN asm_balloc_reset

defc _balloc_reset_fastcall = asm_balloc_reset
