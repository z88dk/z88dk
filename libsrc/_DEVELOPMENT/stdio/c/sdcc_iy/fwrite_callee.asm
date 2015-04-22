
; size_t fwrite_callee(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fwrite_callee

_fwrite_callee:

   pop af
   pop hl
   pop bc
   pop de
   pop ix
   push af

   INCLUDE "stdio/z80/asm_fwrite.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fwrite_callee

EXTERN _fwrite_unlocked_callee

defc _fwrite_callee = _fwrite_unlocked_callee
   
INCLUDE "stdio/z80/asm_fwrite.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
