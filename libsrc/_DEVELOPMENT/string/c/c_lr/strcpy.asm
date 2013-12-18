
XLIB strcpy

XDEF asm_strcpy

strcpy:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcpy
