
; void free_unlocked_fastcall(void *p)

SECTION code_alloc_malloc

PUBLIC _free_unlocked_fastcall

_free_unlocked_fastcall:

   INCLUDE "alloc/malloc/z80/asm_free_unlocked.asm"
