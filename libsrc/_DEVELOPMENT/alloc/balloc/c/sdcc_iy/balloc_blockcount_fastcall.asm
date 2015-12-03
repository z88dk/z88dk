
; size_t balloc_blockcount_fastcall(unsigned int queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC _balloc_blockcount_fastcall

EXTERN asm_balloc_blockcount

defc _balloc_blockcount_fastcall = asm_balloc_blockcount
