
; int getchar(void)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getchar

_getchar:

   push ix
   
   call asm_getchar
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getchar.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _getchar

EXTERN _getchar_unlocked

defc _getchar = _getchar_unlocked
   
INCLUDE "stdio/z80/asm_getchar.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
