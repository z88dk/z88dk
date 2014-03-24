
; void free_unlocked(void *p)

XDEF free_unlocked

;defc free_unlocked = asm_free_unlocked

free_unlocked:

   INCLUDE "alloc/malloc/z80/asm_free_unlocked.asm"
