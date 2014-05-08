
; void *memalign_unlocked(size_t alignment, size_t size)

PUBLIC memalign_unlocked_callee

EXTERN aligned_alloc_unlocked_callee

;defc memalign_unlocked_callee = aligned_alloc_unlocked_callee

memalign_unlocked_callee:

   jp aligned_alloc_unlocked_callee

INCLUDE "alloc/malloc/z80/asm_memalign_unlocked.asm"
