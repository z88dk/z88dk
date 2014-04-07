
; void *heap_calloc(void *heap, size_t nmemb, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF heap_calloc_callee

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

XDEF heap_calloc_callee

LIB heap_calloc_unlocked_callee

heap_calloc_callee:

   jp heap_calloc_unlocked_callee
   
   INCLUDE "alloc/malloc/z80/asm_heap_calloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
