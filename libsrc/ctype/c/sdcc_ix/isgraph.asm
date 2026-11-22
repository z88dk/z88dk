
; int isgraph(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _isgraph

EXTERN _isgraph_fastcall

_isgraph:

   pop af
   pop hl
   
   push hl
   push af

   jp _isgraph_fastcall
