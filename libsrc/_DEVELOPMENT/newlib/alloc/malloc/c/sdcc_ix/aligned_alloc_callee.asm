
; void *aligned_alloc_callee(size_t alignment, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _aligned_alloc_callee

EXTERN asm_aligned_alloc

_aligned_alloc_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_aligned_alloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _aligned_alloc_callee

EXTERN _aligned_alloc_unlocked_callee

defc _aligned_alloc_callee = _aligned_alloc_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
