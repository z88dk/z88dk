; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strcmp
PUBLIC _strcmp
EXTERN strcmp1


.strcmp
._strcmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strcmp1

