
; int ungetc_callee(int c, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ungetc_callee, l0_ungetc_callee

EXTERN asm_ungetc

_ungetc_callee:

   pop af
   pop hl
   pop bc
   push af

l0_ungetc_callee:

   push bc
   ex (sp),ix
   
   call asm_ungetc
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ungetc_callee

EXTERN _ungetc_unlocked_callee

defc _ungetc_callee = _ungetc_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
