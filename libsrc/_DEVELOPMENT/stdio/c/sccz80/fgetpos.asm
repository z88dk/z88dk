
; int fgetpos(FILE *stream, fpos_t *pos)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fgetpos

EXTERN asm_fgetpos

fgetpos:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_fgetpos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fgetpos

EXTERN fgetpos_unlocked

defc fgetpos = fgetpos_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
