
XLIB strcasecmp

LIB asm_strcasecmp

strcasecmp:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcasecmp
