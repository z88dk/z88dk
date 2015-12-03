
; int vfscanf_callee(FILE *stream, const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfscanf_callee

EXTERN asm_vfscanf

_vfscanf_callee:

   pop af
   pop ix
   pop de
   pop bc
   push af
   
   jp asm_vfscanf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfscanf_callee

EXTERN _vfscanf_unlocked_callee

defc _vfscanf_callee = _vfscanf_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
