
; int fsetpos(FILE *stream, const fpos_t *pos)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fsetpos_callee

EXTERN asm_fsetpos

fsetpos_callee:

   pop hl
   pop de
   pop bc

   push ix
   push bc
   pop ix
   ex (sp),hl
   push hl
   ex de,hl

   call asm_fsetpos
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fsetpos_callee

EXTERN fsetpos_unlocked_callee

defc fsetpos_callee = fsetpos_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
