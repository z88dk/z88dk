
; char *gets_fastcall(char *s)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _gets_fastcall

_gets_fastcall:

   push ix
   
   call asm_gets
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_gets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _gets_fastcall

EXTERN _gets_unlocked_fastcall

defc _gets_fastcall = _gets_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_gets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
