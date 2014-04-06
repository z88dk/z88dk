
; int fscanf(FILE *stream, const char *format, ...)

INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _fscanf

_fscanf:

   push ix
   
   call asm_fscanf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XDEF _fscanf

LIB _fscanf_unlocked

_fscanf:

   jp _fscanf_unlocked
   
   INCLUDE "stdio/z80/asm_fscanf.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
