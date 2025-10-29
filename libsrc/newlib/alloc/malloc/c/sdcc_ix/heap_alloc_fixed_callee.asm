
; void *heap_alloc_fixed_callee(void *heap, void *p, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_alloc_fixed_callee

EXTERN asm_heap_alloc_fixed

_heap_alloc_fixed_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_heap_alloc_fixed

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _heap_alloc_fixed_callee

EXTERN _heap_alloc_fixed_unlocked_callee

defc _heap_alloc_fixed_callee = _heap_alloc_fixed_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
