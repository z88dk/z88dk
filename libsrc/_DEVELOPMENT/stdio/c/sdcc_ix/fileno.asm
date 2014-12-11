
; int fileno(FILE *stream)

INCLUDE "clib_cfg.asm"

SECTION code_stdio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fileno

_fileno:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix 
   
   ld ixl,c
   ld ixh,b
   
   call asm_fileno
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fileno.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC _fileno

EXTERN _fileno_unlocked

defc _fileno = _fileno_unlocked

INCLUDE "stdio/z80/asm_fileno.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
