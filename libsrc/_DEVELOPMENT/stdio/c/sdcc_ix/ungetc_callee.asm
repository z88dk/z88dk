
; int ungetc_callee(int c, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ungetc_callee, l0_ungetc_callee

_ungetc_callee:

   pop af
   pop hl
   pop bc
   push af

l0_ungetc_callee:

   push bc
   ex (sp),ix
   
   call asm_ungetc
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_ungetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ungetc_callee

EXTERN _ungetc_unlocked_callee

defc _ungetc_callee = _ungetc_unlocked_callee
   
INCLUDE "stdio/z80/asm_ungetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
