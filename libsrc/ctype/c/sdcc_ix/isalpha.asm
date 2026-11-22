
; int isalpha(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isalpha

EXTERN _isalpha_fastcall

_isalpha:

   pop af
   pop hl
   
   push hl
   push af

   jp _isalpha_fastcall
