
; void *heap_alloc_aligned_callee(void *heap, size_t alignment, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_alloc_aligned_callee

EXTERN asm_heap_alloc_aligned

_heap_alloc_aligned_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_heap_alloc_aligned

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_alloc_aligned_callee

EXTERN _heap_alloc_aligned_unlocked_callee

defc _heap_alloc_aligned_callee = _heap_alloc_aligned_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
