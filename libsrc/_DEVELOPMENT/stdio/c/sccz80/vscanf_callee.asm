
; int vscanf(const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vscanf_callee

vscanf_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_vscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vscanf_callee

EXTERN vscanf_unlocked_callee

defc vscanf_callee = vscanf_unlocked_callee
   
INCLUDE "stdio/z80/asm_vscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
