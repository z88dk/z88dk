
; int fflush_fastcall(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fflush_fastcall

_fflush_fastcall:

   push hl
   pop ix

   INCLUDE "stdio/z80/asm_fflush.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fflush_fastcall

EXTERN _fflush_unlocked_fastcall

defc _fflush_fastcall = _fflush_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_fflush.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
