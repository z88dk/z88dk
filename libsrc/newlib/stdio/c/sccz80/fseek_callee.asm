
; int fseek(FILE *stream, long offset, int whence)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fseek_callee

EXTERN asm_fseek

fseek_callee:

   pop hl
   pop bc
   pop de
   pop af
   ex (sp),hl

   push ix
   ld ix,hl

   push de
   push af
   pop de
   pop hl

   call asm_fseek
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fseek_callee

EXTERN fseek_unlocked_callee

defc fseek_callee = fseek_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
