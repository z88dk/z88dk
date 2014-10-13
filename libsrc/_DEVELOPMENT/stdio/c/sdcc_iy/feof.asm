
; int feof(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _feof

_feof:

   pop af
   pop ix
   
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_feof.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _feof

EXTERN _feof_unlocked

defc _feof = _feof_unlocked
   
INCLUDE "stdio/z80/asm_feof.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
