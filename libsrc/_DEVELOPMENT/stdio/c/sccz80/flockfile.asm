
; void flockfile(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC flockfile

EXTERN asm_flockfile

flockfile:

   push hl
   pop ix
   
   jp asm_flockfile
