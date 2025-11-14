
; int ftrylockfile (FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ftrylockfile

EXTERN asm_ftrylockfile

_ftrylockfile:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_ftrylockfile
