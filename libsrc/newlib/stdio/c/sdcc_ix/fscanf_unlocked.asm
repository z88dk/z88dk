
; int fscanf_unlocked(FILE *stream, const char *format, ...)

SECTION code_clib
SECTION code_stdio

PUBLIC _fscanf_unlocked

EXTERN asm_fscanf_unlocked

_fscanf_unlocked:

   push ix
   
   call asm_fscanf_unlocked
   
   pop ix
   ret
