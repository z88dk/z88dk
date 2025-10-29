
; int isxdigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isxdigit

EXTERN _isxdigit_fastcall

_isxdigit:

   pop af
   pop hl
   
   push hl
   push af

   jp _isxdigit_fastcall
