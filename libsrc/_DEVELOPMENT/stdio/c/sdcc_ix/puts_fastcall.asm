; int puts(const char *s)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _puts_fastcall

_puts_fastcall:

   push ix
   
   call asm_puts
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_puts.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _puts_fastcall

EXTERN _puts_unlocked_fastcall

defc _puts_fastcall = _puts_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_puts.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
