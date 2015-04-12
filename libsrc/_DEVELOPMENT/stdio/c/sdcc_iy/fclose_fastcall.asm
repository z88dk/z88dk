
; int fclose_fastcall(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fclose_fastcall

_fclose_fastcall:

   push hl
   pop ix
      
   INCLUDE "stdio/z80/asm_fclose.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fclose_fastcall

EXTERN _fclose_unlocked_fastcall

defc _fclose_fastcall = _fclose_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_fclose.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
