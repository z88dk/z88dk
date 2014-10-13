
; int fgetpos(FILE *stream, fpos_t *pos)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetpos

_fgetpos:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fgetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetpos

EXTERN _fgetpos_unlocked

defc _fgetpos = _fgetpos_unlocked
   
INCLUDE "stdio/z80/asm_fgetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
