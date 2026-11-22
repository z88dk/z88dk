
; size_t fread_callee(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fread_callee, l0_fread_callee

EXTERN asm_fread

_fread_callee:

   pop af
   pop de
   pop bc
   pop hl
   exx
   pop bc
   push af

l0_fread_callee:

   push bc
   exx
   
   ex (sp),ix
   
   call asm_fread
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fread_callee

EXTERN _fread_unlocked_callee

defc _fread_callee = _fread_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
