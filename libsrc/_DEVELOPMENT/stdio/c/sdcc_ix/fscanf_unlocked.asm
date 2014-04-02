
; int fscanf_unlocked(FILE *stream, const char *format, ...)

XDEF _fscanf_unlocked

_fscanf_unlocked:

   push ix
   
   call asm_fscanf_unlocked
   
   pop ix
   ret

   INCLUDE "stdio/z80/asm_fscanf_unlocked.asm"
