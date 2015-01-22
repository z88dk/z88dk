
; int fputs(const char *s, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputs

_fputs:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   push bc
   ex (sp),ix
   
   call asm_fputs
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fputs.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputs

EXTERN _fputs_unlocked

defc _fputs = _fputs_unlocked
   
INCLUDE "stdio/z80/asm_fputs.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
