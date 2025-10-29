
; int isblank(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isblank

EXTERN _isblank_fastcall

_isblank:

   pop af
   pop hl
   
   push hl
   push af

   jp _isblank_fastcall
