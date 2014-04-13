
; void *heap_calloc(void *heap, size_t nmemb, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _heap_calloc

_heap_calloc:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_calloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _heap_calloc

LIB _heap_calloc_unlocked

_heap_calloc:

   jp _heap_calloc_unlocked
   
   INCLUDE "alloc/malloc/z80/asm_heap_calloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
