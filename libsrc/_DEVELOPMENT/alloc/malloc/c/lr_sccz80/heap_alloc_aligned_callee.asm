
; void *heap_alloc_aligned(void *heap, size_t alignment, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_alloc_aligned_callee

heap_alloc_aligned_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_aligned.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC heap_alloc_aligned_callee

EXTERN heap_alloc_aligned_unlocked_callee

heap_alloc_aligned_callee:

   jp heap_alloc_aligned_unlocked_callee
   
   INCLUDE "alloc/malloc/z80/asm_heap_alloc_aligned.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
