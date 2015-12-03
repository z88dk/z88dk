
; size_t balloc_blockcount(unsigned int queue)

SECTION code_clib
SECTION code_alloc_balloc

PUBLIC balloc_blockcount

EXTERN asm_balloc_blockcount

defc balloc_blockcount = asm_balloc_blockcount
