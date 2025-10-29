
; int islower(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _islower

EXTERN _islower_fastcall

_islower:

   pop af
   pop hl
   
   push hl
   push af

   jp _islower_fastcall
