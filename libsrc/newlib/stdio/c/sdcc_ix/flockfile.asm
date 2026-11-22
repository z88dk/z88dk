
; void flockfile(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC _flockfile

EXTERN _flockfile_fastcall

_flockfile:

   pop af
   pop hl
   
   push hl
   push af

   jp _flockfile_fastcall
