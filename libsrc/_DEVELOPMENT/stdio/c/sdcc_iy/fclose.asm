
; int fclose(FILE *stream)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _fclose

_fclose:

   pop af
   pop ix
   
   push ix
   push af
      
   INCLUDE "stdio/z80/asm_fclose.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _fclose

LIB _fclose_unlocked

_fclose:

   jp _fclose_unlocked
   
   INCLUDE "stdio/z80/asm_fclose.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
