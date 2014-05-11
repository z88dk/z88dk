
; int fsetpos(FILE *stream, const fpos_t *pos)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fsetpos_callee

fsetpos_callee:

   pop af
   pop hl
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fsetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fsetpos_callee

EXTERN fsetpos_unlocked_callee

fsetpos_callee:

   jp fsetpos_unlocked_callee

   INCLUDE "stdio/z80/asm_fsetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
