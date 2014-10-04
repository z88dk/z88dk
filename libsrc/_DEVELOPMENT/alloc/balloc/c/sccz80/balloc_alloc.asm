
; void *balloc_alloc(unsigned int queue)

SECTION seg_code_balloc

PUBLIC balloc_alloc

balloc_alloc:

   INCLUDE "alloc/balloc/z80/asm_balloc_alloc.asm"
