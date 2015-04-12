
; int fileno_fastcall(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fileno_fastcall

_fileno_fastcall:
   
   push hl
   pop ix
      
   INCLUDE "stdio/z80/asm_fileno.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fileno_fastcall

EXTERN _fileno_unlocked_fastcall

defc _fileno_fastcall = _fileno_unlocked_fastcall

INCLUDE "stdio/z80/asm_fileno.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
