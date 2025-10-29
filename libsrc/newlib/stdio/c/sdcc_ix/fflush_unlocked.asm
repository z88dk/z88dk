
; int fflush_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fflush_unlocked

EXTERN _fflush_unlocked_fastcall

_fflush_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _fflush_unlocked_fastcall
