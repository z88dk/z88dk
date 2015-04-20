
; void *realloc_callee(void *p, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _realloc_callee

_realloc:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_realloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _realloc_callee

EXTERN _realloc_unlocked_callee

defc _realloc_callee = _realloc_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_realloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
