
; int fileno_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fileno_unlocked

EXTERN _fileno_unlocked_fastcall

_fileno_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _fileno_unlocked_fastcall
