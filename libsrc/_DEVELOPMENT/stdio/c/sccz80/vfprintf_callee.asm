
; int vfprintf(FILE *stream, const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vfprintf_callee

vfprintf_callee:
   
   pop af
   pop bc
   pop de
   pop ix
   push af

   INCLUDE "stdio/z80/asm_vfprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vfprintf_callee

EXTERN vfprintf_unlocked_callee

defc vfprintf_callee = vfprintf_unlocked_callee
   
INCLUDE "stdio/z80/asm_vfprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
