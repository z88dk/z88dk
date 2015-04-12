
; int putchar_fastcall(int c)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _putchar_fastcall

_putchar:

   INCLUDE "stdio/z80/asm_putchar.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _putchar_fastcall

EXTERN _putchar_unlocked_fastcall

defc _putchar_fastcall = _putchar_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_putchar.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
