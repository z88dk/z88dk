
; int isalnum(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isalnum

EXTERN _isalnum_fastcall

_isalnum:

   pop af
   pop hl
   
   push hl
   push af

   jp _isalnum_fastcall
