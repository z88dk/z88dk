
XLIB strncat

LIB asm_strncat

strncat:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strncat
