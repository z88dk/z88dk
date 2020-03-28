; void in_MouseSimInit(struct in_UDM *u)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC in_MouseSimInit
PUBLIC _in_MouseSimInit
EXTERN in_MouseSimInit_fastcall

.in_MouseSimInit
._in_MouseSimInit

   pop de
   pop hl
   push hl
   push de
   
   jp in_MouseSimInit_fastcall
