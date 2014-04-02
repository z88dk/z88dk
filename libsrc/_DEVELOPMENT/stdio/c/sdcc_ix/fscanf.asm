
; int fscanf(FILE *stream, const char *format, ...)

XDEF _fscanf

_fscanf:

   push ix
   
   call asm_fscanf
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fscanf.asm"
