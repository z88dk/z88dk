
; int getc_fastcall(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getc_fastcall

EXTERN _fgetc_fastcall

defc _getc_fastcall = _fgetc_fastcall

INCLUDE "stdio/z80/asm_getc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getc_fastcall

EXTERN _getc_unlocked_fastcall

defc _getc_fastcall = _getc_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_getc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
