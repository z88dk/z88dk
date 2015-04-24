
; void heap_free_callee(void *heap, void *p)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_free_callee

_heap_free_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "alloc/malloc/z80/asm_heap_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_free_callee

EXTERN _heap_free_unlocked_callee

defc _heap_free_callee = _heap_free_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_heap_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
