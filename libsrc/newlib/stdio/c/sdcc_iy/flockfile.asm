
; void flockfile(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC _flockfile

EXTERN asm_flockfile

_flockfile:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_flockfile
