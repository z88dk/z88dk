
; int fscanf(FILE *stream, const char *format, ...)

XDEF fscanf

fscanf:

   push ix
   
   call asm_fscanf
   
   pop ix
   ret

   INCLUDE "../../z80/asm_fscanf.asm"
