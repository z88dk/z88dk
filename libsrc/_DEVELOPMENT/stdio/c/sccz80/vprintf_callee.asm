
; int vprintf(const char *format, void *arg)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vprintf_callee

vprintf_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "stdio/z80/asm_vprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC vprintf_callee

EXTERN vprintf_unlocked_callee

vprintf_callee:

   jp vprintf_unlocked_callee
   
   INCLUDE "stdio/z80/asm_vprintf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
