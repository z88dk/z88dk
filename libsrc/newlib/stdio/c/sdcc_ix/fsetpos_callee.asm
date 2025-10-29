
; int fsetpos_callee(FILE *stream, const fpos_t *pos)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fsetpos_callee, l0_fsetpos_callee

EXTERN asm_fsetpos

_fsetpos_callee:

   pop hl
   pop bc
   ex (sp),hl

l0_fsetpos_callee:
   
   push bc
   ex (sp),ix
   
   call asm_fsetpos
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fsetpos_callee

EXTERN _fsetpos_unlocked_callee

defc _fsetpos_callee = _fsetpos_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
