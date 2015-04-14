
; void balloc_free_fastcall(void *m)

SECTION code_alloc_balloc

PUBLIC _balloc_free_fastcall

_balloc_free_fastcall:

   INCLUDE "alloc/balloc/z80/asm_balloc_free.asm"
