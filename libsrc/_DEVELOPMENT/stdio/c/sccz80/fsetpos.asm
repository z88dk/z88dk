
; int fsetpos(FILE *stream, const fpos_t *pos)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fsetpos

EXTERN asm_fsetpos

fsetpos:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_fsetpos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fsetpos

EXTERN fsetpos_unlocked

defc fsetpos = fsetpos_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

