
; size_t fwrite_callee(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fwrite_callee, l0_fwrite_callee

EXTERN asm_fwrite

_fwrite_callee:

   pop af
   pop hl
   pop bc
   pop de
   exx
   pop bc
   push af

l0_fwrite_callee:

   push bc
   exx
   
   ex (sp),ix
      
   call asm_fwrite
   
   pop ix
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fwrite_callee

EXTERN _fwrite_unlocked_callee

defc _fwrite_callee = _fwrite_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
