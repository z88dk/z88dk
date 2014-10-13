
; char *gets(char *s)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _gets

_gets:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_gets
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_gets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _gets

EXTERN _gets_unlocked

defc _gets = _gets_unlocked
   
INCLUDE "stdio/z80/asm_gets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
