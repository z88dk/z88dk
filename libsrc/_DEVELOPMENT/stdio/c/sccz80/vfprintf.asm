
; int vfprintf(FILE *stream, const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vfprintf

EXTERN asm_vfprintf

vfprintf:
   
   pop af
   pop bc
   pop de
   pop ix
   
   push ix
   push de
   push bc
   push af

   jp asm_vfprintf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vfprintf

EXTERN vfprintf_unlocked

defc vfprintf = vfprintf_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
