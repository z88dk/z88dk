
; size_t getline_callee(char **lineptr, size_t *n, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getline_callee

_getline_callee:

   pop af
   pop hl
   pop de
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_getline.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getline_callee

EXTERN _getline_unlocked_callee

defc _getline_callee = _getline_unlocked_callee
   
INCLUDE "stdio/z80/asm_getline.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
