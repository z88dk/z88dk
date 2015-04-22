
; int fputs_callee(const char *s, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputs_callee, l0_fputs_callee

_fputs_callee:

   pop af
   pop hl
   pop bc
   push af

l0_fputs_callee:

   push bc
   ex (sp),ix
   
   call asm_fputs
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fputs.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputs_callee

EXTERN _fputs_unlocked_callee

defc _fputs_callee = _fputs_unlocked_callee
   
INCLUDE "stdio/z80/asm_fputs.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
