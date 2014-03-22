
; int fscanf_unlocked(FILE *stream, const char *format, ...)

XDEF fscanf_unlocked

fscanf_unlocked:

   push ix
   
   call asm_fscanf_unlocked
   
   pop ix
   ret

   INCLUDE "../../z80/asm_fscanf_unlocked.asm"
