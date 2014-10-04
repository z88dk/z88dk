
; void balloc_free(void *m)

SECTION seg_code_balloc

PUBLIC balloc_free

balloc_free:

   INCLUDE "alloc/balloc/z80/asm_balloc_free.asm"
