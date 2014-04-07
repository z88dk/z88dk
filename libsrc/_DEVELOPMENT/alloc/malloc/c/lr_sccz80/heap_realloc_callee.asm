
; void *heap_realloc(void *heap, void *p, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF heap_realloc_callee

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

XDEF heap_realloc_callee

LIB heap_realloc_unlocked_callee

heap_realloc_callee:

   jp heap_realloc_unlocked_callee
   
   INCLUDE "alloc/malloc/z80/asm_heap_realloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
