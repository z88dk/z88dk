
; int fseek(FILE *stream, long offset, int whence)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fseek_callee

fseek_callee:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af
   
   INCLUDE "stdio/z80/asm_fseek.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC fseek_callee

EXTERN fseek_unlocked_callee

defc fseek_callee = fseek_unlocked_callee

INCLUDE "stdio/z80/asm_fseek.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
