
; char *fgets(char *s, int n, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgets

_fgets:

   pop af
   pop de
   pop bc
   pop ix
   
   push ix
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_fgets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgets

EXTERN _fgets_unlocked

defc _fgets = _fgets_unlocked
   
INCLUDE "stdio/z80/asm_fgets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
