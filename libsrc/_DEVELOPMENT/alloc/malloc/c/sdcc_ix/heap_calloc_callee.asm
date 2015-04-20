
; void *heap_calloc_callee(void *heap, size_t nmemb, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_calloc_callee

_heap_calloc_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_calloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_calloc_callee

EXTERN _heap_calloc_unlocked_callee

defc _heap_calloc_callee = _heap_calloc_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_heap_calloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
