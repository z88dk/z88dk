
; int vfprintf(FILE *stream, const char *format, void *arg)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vfprintf_callee

EXTERN asm_vfprintf

vfprintf_callee:

   pop hl
   pop bc
   pop de
   pop af

   push ix
   push af
   pop ix
   ex (sp),hl
   push hl

   call asm_vfprintf
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vfprintf_callee

EXTERN vfprintf_unlocked_callee

defc vfprintf_callee = vfprintf_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
