
; char *fgets_callee(char *s, int n, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgets_callee, l0_fgets_callee

EXTERN asm_fgets

_fgets_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

l0_fgets_callee:

   push de
   ex (sp),ix
   
   ex de,hl
   call asm_fgets
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgets_callee

EXTERN _fgets_unlocked_callee

defc _fgets_callee = _fgets_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
