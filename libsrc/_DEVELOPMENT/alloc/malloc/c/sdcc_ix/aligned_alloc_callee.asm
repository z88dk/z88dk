
; void *aligned_alloc_callee(size_t alignment, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _aligned_alloc_callee

_aligned_alloc_callee:

   pop af
   pop bc
   pop hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_aligned_alloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _aligned_alloc_callee

EXTERN _aligned_alloc_unlocked_callee

defc _aligned_alloc_callee = _aligned_alloc_unlocked_callee
  
INCLUDE "alloc/malloc/z80/asm_aligned_alloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
