; CALLER linkage for function pointers

SECTION code_clib
PUBLIC gotoxy
PUBLIC _gotoxy
PUBLIC ___gotoxy
EXTERN asm_gotoxy

.gotoxy
._gotoxy
.___gotoxy

   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   
   jp asm_gotoxy
