
; int vprintf(const char *format, void *arg)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vprintf

_vprintf:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "stdio/z80/asm_vprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _vprintf

EXTERN _vprintf_unlocked

defc _vprintf = _vprintf_unlocked
   
INCLUDE "stdio/z80/asm_vprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
