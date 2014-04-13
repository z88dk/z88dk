
; void heap_free(void *heap, void *p)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _heap_free

_heap_free:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _heap_free

LIB _heap_free_unlocked

_heap_free:

   jp _heap_free_unlocked
   
   INCLUDE "alloc/malloc/z80/asm_heap_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
