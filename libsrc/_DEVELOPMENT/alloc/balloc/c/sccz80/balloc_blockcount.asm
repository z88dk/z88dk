
; size_t balloc_blockcount(unsigned int queue)

SECTION seg_code_balloc

PUBLIC balloc_blockcount

balloc_blockcount:

   INCLUDE "alloc/balloc/z80/asm_balloc_blockcount.asm"
