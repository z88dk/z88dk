
; int isupper(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isupper

EXTERN _isupper_fastcall

_isupper:

   pop af
   pop hl
   
   push hl
   push af

   jp _isupper_fastcall
