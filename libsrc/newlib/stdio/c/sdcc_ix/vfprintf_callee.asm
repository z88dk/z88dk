
; int vfprintf_callee(FILE *stream, const char *format, void *arg)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf_callee, l0_vfprintf_callee

EXTERN asm_vfprintf

_vfprintf_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

l0_vfprintf_callee:

   push hl
   ex (sp),ix
      
   call asm_vfprintf
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf_callee

EXTERN _vfprintf_unlocked_callee

defc _vfprintf_callee = _vfprintf_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
