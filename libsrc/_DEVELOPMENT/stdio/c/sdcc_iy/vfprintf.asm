
; int vfprintf(FILE *stream, const char *format, void *arg)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf

EXTERN asm_vfprintf

_vfprintf:

   pop af
   pop ix
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp asm_vfprintf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf

EXTERN _vfprintf_unlocked

defc _vfprintf = _vfprintf_unlocked
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
