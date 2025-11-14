
; void funlockfile(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC _funlockfile

EXTERN asm_funlockfile

_funlockfile:

   pop af
   pop ix
   
   push hl
   push af
      
   jp asm_funlockfile
