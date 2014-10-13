
; int fsetpos(FILE *stream, const fpos_t *pos)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fsetpos

_fsetpos:

   pop af
   pop ix
   pop hl
   
   push hl
   push ix
   push af
   
   INCLUDE "stdio/z80/asm_fsetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fsetpos

EXTERN _fsetpos_unlocked

defc _fsetpos = _fsetpos_unlocked
   
INCLUDE "stdio/z80/asm_fsetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
