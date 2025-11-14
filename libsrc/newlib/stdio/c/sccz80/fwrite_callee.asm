
; size_t fwrite(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fwrite_callee

EXTERN asm_fwrite

fwrite_callee:

   pop hl
   pop ix
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_fwrite

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fwrite_callee

EXTERN fwrite_unlocked_callee

defc fwrite_callee = fwrite_unlocked_callee
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
