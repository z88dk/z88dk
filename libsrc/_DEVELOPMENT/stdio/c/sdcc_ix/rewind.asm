
; void rewind(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _rewind

EXTERN _rewind_fastcall

_rewind:

   pop af
   pop hl
   
   push hl
   push af

   jp _rewind_fastcall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _rewind

EXTERN _rewind_unlocked

defc _rewind = _rewind_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
