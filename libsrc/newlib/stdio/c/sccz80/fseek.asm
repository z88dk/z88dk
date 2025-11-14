
; int fseek(FILE *stream, long offset, int whence)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fseek

EXTERN asm_fseek

fseek:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   
   push hl
   push de
   push hl
   push bc
   push af
   
   jp asm_fseek

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fseek

EXTERN fseek_unlocked

defc fseek = fseek_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
