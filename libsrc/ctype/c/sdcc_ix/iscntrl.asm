
; int iscntrl(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC _iscntrl

EXTERN _iscntrl_fastcall

_iscntrl:

   pop af
   pop hl
   
   push hl
   push af

   jp _iscntrl_fastcall
