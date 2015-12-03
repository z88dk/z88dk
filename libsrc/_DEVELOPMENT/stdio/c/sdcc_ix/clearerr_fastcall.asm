
; void clearerr_fastcall(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _clearerr_fastcall

EXTERN asm_clearerr

_clearerr_fastcall:

   push hl
   ex (sp),ix
   
   call asm_clearerr
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _clearerr_fastcall

EXTERN _clearerr_unlocked_fastcall

defc _clearerr_fastcall = _clearerr_unlocked_fastcall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
