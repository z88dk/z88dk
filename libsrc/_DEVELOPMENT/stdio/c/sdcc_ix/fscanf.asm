
; int fscanf(FILE *stream, const char *format, ...)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fscanf

_fscanf:

   push ix
   
   call asm_fscanf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fscanf

EXTERN _fscanf_unlocked

defc _fscanf = _fscanf_unlocked
   
INCLUDE "stdio/z80/asm_fscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
