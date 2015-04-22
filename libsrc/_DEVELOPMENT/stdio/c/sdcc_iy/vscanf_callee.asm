
; int vscanf_callee(const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vscanf_callee

_vscanf_callee:

   pop af
   pop de
   pop bc
   push af
   
   INCLUDE "stdio/z80/asm_vscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vscanf_callee

EXTERN _vscanf_unlocked_callee

defc _vscanf_callee = _vscanf_unlocked_callee

INCLUDE "stdio/z80/asm_vscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
