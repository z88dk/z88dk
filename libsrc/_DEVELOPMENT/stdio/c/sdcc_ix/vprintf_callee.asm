
; int vprintf_callee(const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vprintf_callee, l0_vprintf_callee

_vprintf_callee:

   pop af
   pop de
   pop bc
   push af

l0_vprintf_callee:

   push ix
   
   call asm_vprintf
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vprintf_callee

EXTERN _vprintf_unlocked_callee

defc _vprintf_callee = _vprintf_unlocked_callee
   
INCLUDE "stdio/z80/asm_vprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
