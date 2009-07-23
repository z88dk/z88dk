; CALLER linkage for function pointers

XLIB strcmp
LIB strcmp1


.strcmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strcmp1

