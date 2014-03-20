
; void free_unlocked(void *p)

XDEF free_unlocked

LIB heap_free_unlocked

defc free_unlocked = heap_free_unlocked

INCLUDE "../../z80/asm_free_unlocked.asm"
