
; void *heap_realloc_callee(void *heap, void *p, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_realloc_callee

_heap_realloc_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_realloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_realloc_callee

EXTERN _heap_realloc_unlocked_callee

defc _heap_realloc_callee = _heap_realloc_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_heap_realloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
