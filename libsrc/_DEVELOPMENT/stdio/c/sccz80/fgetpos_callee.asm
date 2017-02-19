
; int fgetpos(FILE *stream, fpos_t *pos)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fgetpos_callee

EXTERN asm_fgetpos

fgetpos_callee:

   pop af
   pop hl
   pop ix
   push af
   
   jp asm_fgetpos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fgetpos_callee

EXTERN fgetpos_unlocked_callee

defc fgetpos_callee = fgetpos_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
