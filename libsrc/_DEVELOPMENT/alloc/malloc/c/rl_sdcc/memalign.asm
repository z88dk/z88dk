
; void *memalign(size_t alignment, size_t size)

XLIB memalign

LIB aligned_alloc

defc memalign = aligned_alloc

INCLUDE "../../z80/asm_memalign.asm"

