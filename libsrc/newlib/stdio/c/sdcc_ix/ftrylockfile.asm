
; int ftrylockfile (FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ftrylockfile

EXTERN _ftrylockfile_fastcall

_ftrylockfile:

   pop af
   pop hl
   
   push hl
   push af

   jp _ftrylockfile_fastcall
