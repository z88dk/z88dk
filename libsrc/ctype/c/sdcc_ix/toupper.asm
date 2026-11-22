
; int toupper(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _toupper

EXTERN _toupper_fastcall

_toupper:

   pop af
   pop hl
   
   push hl
   push af

   jp _toupper_fastcall
