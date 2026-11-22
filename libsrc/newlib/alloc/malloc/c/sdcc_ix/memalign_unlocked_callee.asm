
; void *memalign_unlocked_callee(size_t alignment, size_t size)

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC _memalign_unlocked_callee

EXTERN _aligned_alloc_unlocked_callee

defc _memalign_unlocked_callee = _aligned_alloc_unlocked_callee
