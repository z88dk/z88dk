
; int vfprintf_callee(FILE *stream, const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf_callee

_vfprintf_callee:

   pop af
   pop ix
   pop de
   pop bc
   push af

   INCLUDE "stdio/z80/asm_vfprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vfprintf_callee

EXTERN _vfprintf_unlocked_callee

defc _vfprintf_callee = _vfprintf_unlocked_callee
   
INCLUDE "stdio/z80/asm_vfprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
