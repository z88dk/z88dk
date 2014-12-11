
; void *heap_calloc(void *heap, size_t nmemb, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_calloc_callee

heap_calloc_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_calloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_calloc_callee

EXTERN heap_calloc_unlocked_callee

defc heap_calloc_callee = heap_calloc_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_heap_calloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
