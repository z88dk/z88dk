
; int fputc_callee(int c, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputc_callee

_fputc_callee:

   pop af
   pop de
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fputc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputc_callee

EXTERN _fputc_unlocked_callee

defc _fputc_callee = _fputc_unlocked_callee
   
INCLUDE "stdio/z80/asm_fputc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
