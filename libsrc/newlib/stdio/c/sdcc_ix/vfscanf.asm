
; int vfscanf(FILE *stream, const char *format, void *arg)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfscanf

EXTERN l0_vfscanf_callee

_vfscanf:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp l0_vfscanf_callee
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfscanf

EXTERN _vfscanf_unlocked

defc _vfscanf = _vfscanf_unlocked
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
