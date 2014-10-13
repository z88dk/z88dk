
; int ferror(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION seg_code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ferror

_ferror:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call asm_ferror
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_ferror.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _ferror

EXTERN _ferror_unlocked

defc _ferror = _ferror_unlocked
   
INCLUDE "stdio/z80/asm_ferror.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
