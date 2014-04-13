
; void heap_free(void *heap, void *p)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB heap_free

LIB asm_heap_free

heap_free:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_heap_free

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB heap_free

LIB heap_free_unlocked

heap_free:

   jp heap_free_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
