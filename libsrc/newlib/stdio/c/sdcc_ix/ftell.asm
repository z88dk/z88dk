
; unsigned long ftell(FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ftell

EXTERN _ftell_fastcall

_ftell:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _ftell_fastcall
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ftell

EXTERN _ftell_unlocked

defc _ftell = _ftell_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
