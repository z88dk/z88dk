
; void *aligned_alloc(size_t alignment, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _aligned_alloc

EXTERN asm_aligned_alloc

_aligned_alloc:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_aligned_alloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _aligned_alloc

EXTERN _aligned_alloc_unlocked

defc _aligned_alloc = _aligned_alloc_unlocked
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
