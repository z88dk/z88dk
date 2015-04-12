
; int fgetc_fastcall(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetc_fastcall

_fgetc_fastcall:
   
   push hl
   ex (sp),ix

   call asm_fgetc
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetc_fastcall

EXTERN _fgetc_unlocked_fastcall

defc _fgetc_fastcall = _fgetc_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_fgetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
