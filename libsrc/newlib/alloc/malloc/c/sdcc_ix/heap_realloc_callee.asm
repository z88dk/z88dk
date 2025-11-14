
; void *heap_realloc_callee(void *heap, void *p, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_realloc_callee

EXTERN asm_heap_realloc

_heap_realloc_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_heap_realloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_realloc_callee

EXTERN _heap_realloc_unlocked_callee

defc _heap_realloc_callee = _heap_realloc_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
