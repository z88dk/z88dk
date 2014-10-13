
; int putc(int c, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC putc_callee

EXTERN fputc_callee

defc putc_callee = fputc_callee

INCLUDE "stdio/z80/asm_putc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC putc_callee

EXTERN putc_unlocked_callee

defc putc_callee = putc_unlocked_callee
   
INCLUDE "stdio/z80/asm_putc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
