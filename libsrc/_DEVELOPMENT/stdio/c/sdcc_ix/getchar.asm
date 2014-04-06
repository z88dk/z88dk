
; int getchar(void)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _getchar

_getchar:

   push ix
   
   call asm_getchar
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_getchar.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _getchar

LIB _getchar_unlocked

_getchar:

   jp _getchar_unlocked
   
   INCLUDE "stdio/z80/asm_getchar.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
