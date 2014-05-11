
; int fgetpos(FILE *stream, fpos_t *pos)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fgetpos_callee

fgetpos_callee:

   pop af
   pop hl
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fgetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fgetpos_callee

EXTERN fgetpos_unlocked_callee

fgetpos_callee:

   jp fgetpos_unlocked_callee

   INCLUDE "stdio/z80/asm_fgetpos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
