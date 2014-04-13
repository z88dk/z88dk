
; void heap_info(void *heap, void *callback)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB heap_info

LIB asm_heap_info

heap_info:

   pop af
   pop ix
   pop de
   
   push de
   push ix
   push af
   
   jp asm_heap_info

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XLIB heap_info

LIB heap_info_unlocked

heap_info:

   jp heap_info_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
