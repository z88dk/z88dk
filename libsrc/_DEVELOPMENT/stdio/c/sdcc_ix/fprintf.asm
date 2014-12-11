
; int fprintf(FILE *stream, const char *format, ...)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fprintf

_fprintf:

   push ix
   
   call asm_fprintf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fprintf

EXTERN _fprintf_unlocked

defc _fprintf = _fprintf_unlocked
   
INCLUDE "stdio/z80/asm_fprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
