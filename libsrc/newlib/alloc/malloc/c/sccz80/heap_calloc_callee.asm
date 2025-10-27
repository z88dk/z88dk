
; void *heap_calloc(void *heap, size_t nmemb, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_calloc_callee

EXTERN asm_heap_calloc

heap_calloc_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   jp asm_heap_calloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_calloc_callee

EXTERN heap_calloc_unlocked_callee

defc heap_calloc_callee = heap_calloc_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
