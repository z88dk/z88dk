
; int scanf(const char *format, ...)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC scanf

scanf:

   INCLUDE "stdio/z80/asm_scanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC scanf

EXTERN scanf_unlocked

defc scanf = scanf_unlocked
   
INCLUDE "stdio/z80/asm_scanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
