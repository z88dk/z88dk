
; void *calloc_callee(size_t nmemb, size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _calloc_callee

_calloc_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "alloc/malloc/z80/asm_calloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _calloc_callee

EXTERN _calloc_unlocked_callee

defc _calloc_callee = _calloc_unlocked_callee
   
INCLUDE "alloc/malloc/z80/asm_calloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
