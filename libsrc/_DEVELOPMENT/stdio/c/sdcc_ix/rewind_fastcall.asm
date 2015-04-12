
; void rewind_fastcall(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _rewind_fastcall

_rewind_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_rewind
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_rewind.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _rewind_fastcall

EXTERN _rewind_unlocked_fastcall

defc _rewind_fastcall = _rewind_unlocked_fastcall
   
INCLUDE "stdio/z80/asm_rewind.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
