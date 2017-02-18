
; void *heap_alloc_aligned(void *heap, size_t alignment, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_alloc_aligned_callee

EXTERN asm_heap_alloc_aligned

heap_alloc_aligned_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_heap_alloc_aligned

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_alloc_aligned_callee

EXTERN heap_alloc_aligned_unlocked_callee

defc heap_alloc_aligned_callee = heap_alloc_aligned_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
