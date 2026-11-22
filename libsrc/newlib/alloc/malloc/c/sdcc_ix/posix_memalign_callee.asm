
; int posix_memalign_callee(void **memptr, size_t alignment, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _posix_memalign_callee

EXTERN asm_posix_memalign

_posix_memalign:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_posix_memalign

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _posix_memalign_callee

EXTERN _posix_memalign_unlocked_callee

defc _posix_memalign_callee = _posix_memalign_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
