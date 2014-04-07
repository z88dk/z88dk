
; void *memalign(size_t alignment, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF memalign_callee

LIB aligned_alloc_callee

;defc memalign_callee = aligned_alloc_callee

memalign_callee:

   jp aligned_alloc_callee

   INCLUDE "alloc/malloc/z80/asm_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF memalign_callee

LIB memalign_unlocked_callee

memalign_callee:

   jp memalign_unlocked_callee
   
   INCLUDE "alloc/malloc/z80/asm_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
