
; int isprint(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isprint

EXTERN _isprint_fastcall

_isprint:

   pop af
   pop hl
   
   push hl
   push af

   jp _isprint_fastcall
