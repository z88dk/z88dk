; CALLER linkage for function pointers

PUBLIC strcmp
EXTERN strcmp1


.strcmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strcmp1

