
; int ungetc(int c, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ungetc

EXTERN asm_ungetc

_ungetc:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af

   jp asm_ungetc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ungetc

EXTERN _ungetc_unlocked

defc _ungetc = _ungetc_unlocked
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
