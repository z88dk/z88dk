
; int fgetc_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgetc_unlocked

EXTERN _fgetc_unlocked_fastcall

_fgetc_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _fgetc_unlocked_fastcall
