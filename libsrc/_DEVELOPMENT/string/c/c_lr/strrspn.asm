
XLIB strrspn

LIB asm_strrspn

strrspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strrspn
