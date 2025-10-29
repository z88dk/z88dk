
; int fputs_callee(const char *s, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputs_callee, l0_fputs_callee

EXTERN asm_fputs

_fputs_callee:

   pop af
   pop hl
   pop bc
   push af

l0_fputs_callee:

   push bc
   ex (sp),ix
   
   call asm_fputs
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputs_callee

EXTERN _fputs_unlocked_callee

defc _fputs_callee = _fputs_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
