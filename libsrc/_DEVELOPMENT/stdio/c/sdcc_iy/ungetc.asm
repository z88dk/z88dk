
; int ungetc(int c, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ungetc

_ungetc:

   pop af
   pop hl
   pop ix
   
   push ix
   push hl
   push af

   INCLUDE "stdio/z80/asm_ungetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ungetc

EXTERN _ungetc_unlocked

defc _ungetc = _ungetc_unlocked
   
INCLUDE "stdio/z80/asm_ungetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
