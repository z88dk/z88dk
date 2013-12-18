
XLIB stpcpy

LIB asm_stpcpy

stpcpy:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_stpcpy
