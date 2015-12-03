
; int isdigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isdigit

EXTERN _isdigit_fastcall

_isdigit:

   pop af
   pop hl
   
   push hl
   push af

   jp _isdigit_fastcall
