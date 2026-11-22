
; void heap_info_callee(void *heap, void *callback)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_info_callee, l0_heap_info_callee

EXTERN asm_heap_info

_heap_info_callee:

   pop af
   pop de
   pop bc
   push af

l0_heap_info_callee:

   push bc
   ex (sp),ix
   
   call asm_heap_info
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_info_callee

EXTERN _heap_info_unlocked_callee

defc _heap_info_callee = _heap_info_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
