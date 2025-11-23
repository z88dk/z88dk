
; size_t fread_callee(void *ptr, size_t size, size_t nmemb, FILE *stream)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fread_callee

EXTERN asm_fread

_fread_callee:

   pop af
   pop de
   pop bc
   pop hl
   pop ix
   push af
   
   jp asm_fread

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fread_callee

EXTERN _fread_unlocked_callee

defc _fread_callee = _fread_unlocked_callee

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
