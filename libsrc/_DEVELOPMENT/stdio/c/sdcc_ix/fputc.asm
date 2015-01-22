
; int fputc(int c, FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputc

_fputc:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   push bc
   ex (sp),ix
   
   call asm_fputc
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fputc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fputc

EXTERN _fputc_unlocked

defc _fputc = _fputc_unlocked
   
INCLUDE "stdio/z80/asm_fputc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
