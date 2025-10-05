
; int fclose_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fclose_unlocked

EXTERN _fclose_unlocked_fastcall

_fclose_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _fclose_unlocked_fastcall
