
; int isbdigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isbdigit

EXTERN _isbdigit_fastcall

_isbdigit:

   pop af
   pop hl
   
   push hl
   push af

   jp _isbdigit_fastcall
