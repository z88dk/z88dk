
; int fsetpos(FILE *stream, const fpos_t *pos)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fsetpos

EXTERN l0_fsetpos_callee

_fsetpos:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   jp l0_fsetpos_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fsetpos

EXTERN _fsetpos_unlocked

defc _fsetpos = _fsetpos_unlocked
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
