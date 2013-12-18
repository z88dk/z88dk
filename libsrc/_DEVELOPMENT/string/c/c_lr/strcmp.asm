
XLIB strcmp

LIB asm_strcmp

strcmp:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcmp
