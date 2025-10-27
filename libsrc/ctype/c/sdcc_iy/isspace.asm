
; int isspace(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isspace

EXTERN _isspace_fastcall

_isspace:

   pop af
   pop hl
   
   push hl
   push af

   jp _isspace_fastcall
