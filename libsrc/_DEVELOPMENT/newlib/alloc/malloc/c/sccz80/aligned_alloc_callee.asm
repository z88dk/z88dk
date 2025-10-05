
; void *aligned_alloc(size_t alignment, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC aligned_alloc_callee

EXTERN asm_aligned_alloc

aligned_alloc_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_aligned_alloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC aligned_alloc_callee

EXTERN aligned_alloc_unlocked_callee

defc aligned_alloc_callee = aligned_alloc_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
