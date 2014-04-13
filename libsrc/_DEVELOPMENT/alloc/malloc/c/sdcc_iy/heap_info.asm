
; void heap_info(void *heap, void *callback)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF heap_info

heap_info:

   pop af
   pop de
   pop ix
   
   push ix
   push de
   push af

   INCLUDE "alloc/malloc/z80/asm_heap_info.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF heap_info

LIB heap_info_unlocked

heap_info:

   jp heap_info_unlocked
   
   INCLUDE "alloc/malloc/z80/asm_heap_info.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
