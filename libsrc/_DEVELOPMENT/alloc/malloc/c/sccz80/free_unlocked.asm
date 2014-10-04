
; void free_unlocked(void *p)

SECTON seg_code_malloc

PUBLIC free_unlocked

defc free_unlocked = asm_free_unlocked

INCLUDE "alloc/malloc/z80/asm_free_unlocked.asm"
