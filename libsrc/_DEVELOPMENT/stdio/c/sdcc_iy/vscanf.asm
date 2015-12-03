
; int vscanf(const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vscanf

EXTERN asm_vscanf

_vscanf:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_vscanf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vscanf

EXTERN _vscanf_unlocked

defc _vscanf = _vscanf_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
