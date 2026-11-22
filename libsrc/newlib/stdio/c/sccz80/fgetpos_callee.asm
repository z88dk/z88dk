
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

   pop hl
   pop de
   pop bc

   push ix
   push bc
   pop ix
   ex (sp),hl
   push hl
   ex de,hl

   call asm_fgetpos
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fgetpos_callee

EXTERN fgetpos_unlocked_callee

defc fgetpos_callee = fgetpos_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
