
; int feof_fastcall(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _feof_fastcall

_feof_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_feof
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_feof.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _feof_fastcall

EXTERN _feof_unlocked_fastcall

defc _feof_fastcall = _feof_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_feof.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
