
; int vfscanf_callee(FILE *stream, const char *format, void *arg)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfscanf_callee, l0_vfscanf_callee

EXTERN asm_vfscanf

_vfscanf_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_vfscanf_callee:

   push hl
   ex (sp),ix
   
   call asm_vfscanf
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfscanf_callee

EXTERN _vfscanf_unlocked_callee

defc _vfscanf_callee = _vfscanf_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
