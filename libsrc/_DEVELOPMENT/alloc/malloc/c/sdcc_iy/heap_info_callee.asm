
; void heap_info_callee(void *heap, void *callback)

INCLUDE "clib_cfg.asm"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_info_callee

EXTERN asm_heap_info

_heap_info_callee:

   pop af
   pop de
   pop ix
   push af

   jp asm_heap_info

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_info

EXTERN _heap_info_unlocked

defc _heap_info = _heap_info_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
