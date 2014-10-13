
; int fputs(const char *s, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputs

_fputs:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af
   
   INCLUDE "stdio/z80/asm_fputs.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputs

EXTERN _fputs_unlocked

defc _fputs = _fputs_unlocked
   
INCLUDE "stdio/z80/asm_fputs.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
