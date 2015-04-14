
; size_t balloc_blockcount_fastcall(unsigned int queue)

SECTION code_alloc_balloc

PUBLIC _balloc_blockcount_fastcall

_balloc_blockcount_fastcall:

   INCLUDE "alloc/balloc/z80/asm_balloc_blockcount.asm"
