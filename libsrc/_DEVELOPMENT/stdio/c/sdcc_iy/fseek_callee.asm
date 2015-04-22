
; int fseek_callee(FILE *stream, long offset, int whence)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fseek_callee

_fseek_callee:

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "stdio/z80/asm_fseek.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fseek_callee

EXTERN _fseek_unlocked_callee

defc _fseek_callee = _fseek_unlocked_callee
   
INCLUDE "stdio/z80/asm_fseek.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
