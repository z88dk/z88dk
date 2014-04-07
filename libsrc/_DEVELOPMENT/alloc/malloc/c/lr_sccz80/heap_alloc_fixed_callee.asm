
; void *heap_alloc_fixed(void *heap, void *p, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF heap_alloc_fixed_callee

heap_alloc_fixed_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_fixed.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF heap_alloc_fixed_callee

LIB heap_alloc_fixed_unlocked_callee

heap_alloc_fixed_callee:

   jp heap_alloc_fixed_unlocked_callee
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_fixed.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
