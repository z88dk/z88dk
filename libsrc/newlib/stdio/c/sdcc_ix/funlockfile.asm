
; void funlockfile(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC _funlockfile

EXTERN _funlockfile_fastcall

_funlockfile:

   pop af
   pop hl
   
   push hl
   push af

   jp _funlockfile_fastcall
