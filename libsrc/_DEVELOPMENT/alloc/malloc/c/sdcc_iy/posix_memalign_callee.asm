
; int posix_memalign_callee(void **memptr, size_t alignment, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _posix_memalign_callee

_posix_memalign:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/malloc/z80/asm_posix_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _posix_memalign_callee

EXTERN _posix_memalign_unlocked_callee

defc _posix_memalign_callee = _posix_memalign_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_posix_memalign.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
