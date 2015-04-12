
; void clearerr_fastcall(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _clearerr_fastcall

_clearerr_fastcall:

   pop af
   pop ix
   
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_clearerr.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _clearerr_fastcall

EXTERN _clearerr_unlocked_fastcall

defc _clearerr_fastcall = _clearerr_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_clearerr.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
