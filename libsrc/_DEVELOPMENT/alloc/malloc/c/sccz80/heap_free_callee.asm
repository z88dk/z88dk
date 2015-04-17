
; void heap_free(void *heap, void *p)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_free_callee

heap_free_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_free_callee

EXTERN heap_free_unlocked_callee

defc heap_free_callee = heap_free_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_heap_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
