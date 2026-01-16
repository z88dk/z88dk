
; int ispunct(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _ispunct

EXTERN _ispunct_fastcall

_ispunct:

   pop af
   pop hl
   
   push hl
   push af

   jp _ispunct_fastcall
