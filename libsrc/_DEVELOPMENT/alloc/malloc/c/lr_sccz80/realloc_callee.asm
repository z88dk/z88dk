
; void *realloc(void *p, size_t size)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF realloc_callee

realloc_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/malloc/z80/asm_realloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF realloc_callee

LIB realloc_unlocked_callee

realloc_callee:

   jp realloc_unlocked_callee
   
   INCLUDE "alloc/malloc/z80/asm_realloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
