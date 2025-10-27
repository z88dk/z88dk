
; void *heap_alloc_fixed(void *heap, void *p, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_alloc_fixed_callee

EXTERN asm_heap_alloc_fixed

heap_alloc_fixed_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_heap_alloc_fixed

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_alloc_fixed_callee

EXTERN heap_alloc_fixed_unlocked_callee

defc heap_alloc_fixed_callee = heap_alloc_fixed_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
