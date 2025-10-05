
; void *heap_alloc(void *heap, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_alloc_callee

EXTERN asm_heap_alloc

heap_alloc_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_heap_alloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_alloc_callee

EXTERN heap_alloc_unlocked_callee

defc heap_alloc_callee = heap_alloc_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
