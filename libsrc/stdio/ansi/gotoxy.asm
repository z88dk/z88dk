; CALLER linkage for function pointers

SECTION code_clib
PUBLIC gotoxy
PUBLIC _gotoxy
EXTERN gotoxy_callee
EXTERN ASMDISP_GOTOXY_CALLEE

.gotoxy
._gotoxy

   pop af
   pop de
   pop bc
   push bc
   push de
   push af
   
   jp gotoxy_callee + ASMDISP_GOTOXY_CALLEE
