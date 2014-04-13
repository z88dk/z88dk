
; void heap_info(void *heap, void *callback)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF heap_info_callee

heap_info_callee:

   pop af
   pop ix
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_info.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF heap_info_callee

LIB heap_info_unlocked_callee

heap_info_callee:

   jp heap_info_unlocked_callee
   
   INCLUDE "alloc/malloc/z80/asm_heap_info.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
