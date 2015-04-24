
; void *heap_alloc_aligned_callee(void *heap, size_t alignment, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_alloc_aligned_callee

_heap_alloc_aligned_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_aligned.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_alloc_aligned_callee

EXTERN _heap_alloc_aligned_unlocked_callee

defc _heap_alloc_aligned_callee = _heap_alloc_aligned_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_heap_alloc_aligned.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
