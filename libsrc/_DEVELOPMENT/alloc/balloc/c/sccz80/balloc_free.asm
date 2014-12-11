
; void balloc_free(void *m)

SECTION code_alloc_balloc

PUBLIC balloc_free

balloc_free:

   INCLUDE "alloc/balloc/z80/asm_balloc_free.asm"
