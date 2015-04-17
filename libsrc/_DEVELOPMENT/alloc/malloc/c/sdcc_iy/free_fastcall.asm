
; void free_fastcall(void *p)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _free_fastcall

_free_fastcall:

   INCLUDE "alloc/malloc/z80/asm_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _free_fastcall

EXTERN _free_unlocked_fastcall

defc _free_fastcall = _free_unlocked_fastcall
   
INCLUDE "alloc/malloc/z80/asm_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
