
; int posix_memalign(void **memptr, size_t alignment, size_t size)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC posix_memalign_callee

EXTERN asm_posix_memalign

posix_memalign_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_posix_memalign

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC posix_memalign_callee

EXTERN posix_memalign_unlocked_callee

defc posix_memalign_callee = posix_memalign_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
