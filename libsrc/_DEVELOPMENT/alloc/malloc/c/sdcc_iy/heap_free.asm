
; void heap_free(void *heap, void *p)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_free

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

PUBLIC _heap_free

EXTERN _heap_free_unlocked

defc _heap_free = _heap_free_unlocked
   
INCLUDE "alloc/malloc/z80/asm_heap_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
