
; int fclose(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fclose

EXTERN _fclose_fastcall

_fclose:

   pop af
   pop hl
   
   push hl
   push af

   jp _fclose_fastcall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fclose

EXTERN _fclose_unlocked

defc _fclose = _fclose_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
