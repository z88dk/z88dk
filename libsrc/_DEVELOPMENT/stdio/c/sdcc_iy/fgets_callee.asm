
; char *fgets_callee(char *s, int n, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgets_callee

_fgets_callee:

   pop af
   pop de
   pop bc
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fgets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgets_callee

EXTERN _fgets_unlocked_callee

defc _fgets_callee = _fgets_unlocked_callee
   
INCLUDE "stdio/z80/asm_fgets.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
