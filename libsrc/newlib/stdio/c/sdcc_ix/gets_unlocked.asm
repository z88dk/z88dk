
; char *gets_unlocked(char *s)

SECTION code_clib
SECTION code_stdio

PUBLIC _gets_unlocked

EXTERN _gets_unlocked_fastcall

_gets_unlocked:

   pop af
   pop hl
   
   push hl
   push af

   jp _gets_unlocked_fastcall
