
; void *_falloc__callee(void *p, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __falloc__callee

__falloc__callee:

   pop af
   pop bc
   pop hl
   push af
   
   INCLUDE "alloc/malloc/z80/asm__falloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __falloc__callee

EXTERN __falloc__unlocked_callee

defc __falloc__callee = __falloc__unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm__falloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
