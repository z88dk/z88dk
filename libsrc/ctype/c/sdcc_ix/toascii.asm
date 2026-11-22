
; int toascii(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _toascii

EXTERN _toascii_fastcall

_toascii:

   pop af
   pop hl
   
   push hl
   push af

   jp _toascii_fastcall
