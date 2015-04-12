
; int ferror(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ferror_fastcall

_ferror_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_ferror
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_ferror.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ferror_fastcall

EXTERN _ferror_unlocked_fastcall

defc _ferror_fastcall = _ferror_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_ferror.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
