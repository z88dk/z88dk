
; int fgetc(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetc

_fgetc:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix

   call asm_fgetc
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fgetc

EXTERN _fgetc_unlocked

defc _fgetc = _fgetc_unlocked
   
INCLUDE "stdio/z80/asm_fgetc.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
