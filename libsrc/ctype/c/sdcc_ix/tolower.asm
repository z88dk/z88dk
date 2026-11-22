
; int tolower(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _tolower

EXTERN _tolower_fastcall

_tolower:

   pop af
   pop hl
   
   push hl
   push af

   jp _tolower_fastcall
