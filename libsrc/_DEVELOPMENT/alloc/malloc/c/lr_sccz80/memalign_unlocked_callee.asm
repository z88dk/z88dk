
; void *memalign_unlocked(size_t alignment, size_t size)

XDEF memalign_unlocked_callee

LIB aligned_alloc_unlocked_callee

defc memalign_unlocked_callee = aligned_alloc_unlocked_callee

INCLUDE "../../z80/asm_memalign_unlocked.asm"
