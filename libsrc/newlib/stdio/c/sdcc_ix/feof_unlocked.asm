
; int feof_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _feof_unlocked

EXTERN _feof_unlocked_fastcall

_feof_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _feof_unlocked_fastcall
