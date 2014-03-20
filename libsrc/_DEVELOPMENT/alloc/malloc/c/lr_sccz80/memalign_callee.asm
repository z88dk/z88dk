
; void *memalign(size_t alignment, size_t size)

XDEF memalign_callee

LIB aligned_alloc_callee

defc memalign_callee = aligned_alloc_callee

INCLUDE "../../z80/asm_memalign.asm"
