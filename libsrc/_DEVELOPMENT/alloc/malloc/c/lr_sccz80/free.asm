
; void free(void *p)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF free

free:

   INCLUDE "alloc/malloc/z80/asm_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF free

LIB free_unlocked

free:

   jp free_unlocked
   
   INCLUDE "alloc/malloc/z80/asm_free.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
