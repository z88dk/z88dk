
; int ferror_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ferror_unlocked

EXTERN _ferror_unlocked_fastcall

_ferror_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _ferror_unlocked_fastcall
