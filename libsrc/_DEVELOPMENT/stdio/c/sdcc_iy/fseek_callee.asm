
; int fseek_callee(FILE *stream, long offset, int whence)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fseek_callee

EXTERN asm_fseek

_fseek_callee:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_fseek

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fseek_callee

EXTERN _fseek_unlocked_callee

defc _fseek_callee = _fseek_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
