
; int fgetpos_callee(FILE *stream, fpos_t *pos)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetpos_callee, l0_fgetpos_callee

EXTERN asm_fgetpos

_fgetpos_callee:

   pop af
   pop bc
   pop hl
   push af

l0_fgetpos_callee:

   push bc
   ex (sp),ix
   
   call asm_fgetpos
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetpos_callee

EXTERN _fgetpos_unlocked_callee

defc _fgetpos_callee = _fgetpos_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
