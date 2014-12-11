
; void *heap_realloc(void *heap, void *p, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_realloc_callee

heap_realloc_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_realloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_realloc_callee

EXTERN heap_realloc_unlocked_callee

defc heap_realloc_callee = heap_realloc_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_heap_realloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
