
; int ungetc(int c, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC ungetc_callee

ungetc_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_ungetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC ungetc_callee

EXTERN ungetc_unlocked_callee

dfc ungetc_callee = ungetc_unlocked_callee
   
INCLUDE "stdio/z80/asm_ungetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
