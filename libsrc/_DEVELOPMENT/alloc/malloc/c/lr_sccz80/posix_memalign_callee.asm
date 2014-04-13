
; int posix_memalign(void **memptr, size_t alignment, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF posix_memalign_callee

posix_memalign_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "alloc/malloc/z80/asm_posix_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF posix_memalign_callee

LIB posix_memalign_unlocked_callee

posix_memalign_callee:

   jp posix_memalign_unlocked_callee
   
   INCLUDE "alloc/malloc/z80/asm_posix_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
