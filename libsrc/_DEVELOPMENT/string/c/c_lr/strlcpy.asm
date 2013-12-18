
XLIB strlcpy

LIB asm_strlcpy

strlcpy:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strlcpy
