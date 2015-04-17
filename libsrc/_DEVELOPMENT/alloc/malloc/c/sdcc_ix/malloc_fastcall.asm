
; void *malloc_fastcall(size_t size)

INCLUDE "clib_cfg.asm"

SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _malloc_fastcall

_malloc_fastcall:

   INCLUDE "alloc/malloc/z80/asm_malloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _malloc_fastcall

EXTERN _malloc_unlocked_fastcall

defc _malloc_fastcall = _malloc_unlocked_fastcall
   
INCLUDE "alloc/malloc/z80/asm_malloc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
