
; void funlockfile(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC funlockfile

EXTERN asm_funlockfile

funlockfile:

   push hl
   pop ix
   
   jp asm_funlockfile
