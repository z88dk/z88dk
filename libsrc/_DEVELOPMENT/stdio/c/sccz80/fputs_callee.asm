
; int fputs(const char *s, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fputs_callee

fputs_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_fputs.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fputs_callee

EXTERN fputs_unlocked_callee

defc fputs_callee = fputs_unlocked_callee
   
INCLUDE "stdio/z80/asm_fputs.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
