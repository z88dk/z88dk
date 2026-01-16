
; size_t getdelim_callee(char **lineptr, size_t *n, int delimiter, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getdelim_callee, l0_getdelim_callee

EXTERN asm_getdelim

_getdelim_callee:

   pop af
   pop hl
   pop de
   pop bc
   exx
   pop bc
   push af

l0_getdelim_callee:

   push bc
   exx
   
   ex (sp),ix
   
   call asm_getdelim
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getdelim_callee

EXTERN _getdelim_unlocked_callee

defc _getdelim_callee = _getdelim_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
