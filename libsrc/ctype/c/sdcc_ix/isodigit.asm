
; int isodigit(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isodigit

EXTERN _isodigit_fastcall

_isodigit:

   pop af
   pop hl
   
   push hl
   push af

   jp _isodigit_fastcall
