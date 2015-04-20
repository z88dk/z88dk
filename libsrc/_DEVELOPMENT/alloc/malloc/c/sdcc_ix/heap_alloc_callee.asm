
; void *heap_alloc_callee(void *heap, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_alloc_callee

_heap_alloc_callee:

   pop af
   pop de
   pop hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_alloc_callee

EXTERN _heap_alloc_unlocked_callee

defc _heap_alloc_callee = _heap_alloc_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_heap_alloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
