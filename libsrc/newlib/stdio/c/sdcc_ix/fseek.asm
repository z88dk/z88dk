
; int fseek(FILE *stream, long offset, int whence)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fseek

EXTERN l0_fseek_callee

_fseek:

   pop af
   exx
   pop bc
   exx
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push bc
   push af
   
   jp l0_fseek_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fseek

EXTERN _fseek_unlocked

defc _fseek = _fseek_unlocked
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
