
; int vfprintf(FILE *stream, const char *format, void *arg)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vfprintf_callee

EXTERN asm_vfprintf

vfprintf_callee:
   
   pop af
   pop bc
   pop de
   pop ix
   push af

   jp asm_vfprintf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vfprintf_callee

EXTERN vfprintf_unlocked_callee

defc vfprintf_callee = vfprintf_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
