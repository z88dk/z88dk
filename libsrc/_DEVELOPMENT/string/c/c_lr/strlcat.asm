
XLIB strlcat

LIB asm_strlcat

strlcat:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_strlcat
