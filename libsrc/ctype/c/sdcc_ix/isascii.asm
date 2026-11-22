
; int isascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isascii

EXTERN _isascii_fastcall

_isascii:

   pop af
   pop hl
   
   push hl
   push af

   jp _isascii_fastcall
