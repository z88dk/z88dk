
; void free_unlocked(void *p)

SECTION seg_code_malloc

PUBLIC _free_unlocked

EXTERN _heap_free_unlocked

defc _free_unlocked = _heap_free_unlocked

INCLUDE "alloc/malloc/z80/asm_free_unlocked.asm"
