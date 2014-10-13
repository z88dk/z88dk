
; int putc(int c, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _putc

EXTERN _fputc

defc _putc = _fputc

INCLUDE "stdio/z80/asm_putc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _putc

EXTERN _putc_unlocked

defc _putc = _putc_unlocked
   
INCLUDE "stdio/z80/asm_putc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
