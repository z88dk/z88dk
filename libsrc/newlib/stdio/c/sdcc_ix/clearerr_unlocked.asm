
; void clearerr_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _clearerr_unlocked

EXTERN _clearerr_unlocked_fastcall

_clearerr_unlocked:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _clearerr_unlocked_fastcall
