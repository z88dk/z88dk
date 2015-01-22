
; int fclose(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fclose

_fclose:

   pop af
   pop bc
   
   push bc
   push af

   push bc
   ex (sp),ix
   
   call asm_fclose
   
   pop ix
   ret
      
   INCLUDE "stdio/z80/asm_fclose.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fclose

EXTERN _fclose_unlocked

defc _fclose = _fclose_unlocked
   
INCLUDE "stdio/z80/asm_fclose.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
