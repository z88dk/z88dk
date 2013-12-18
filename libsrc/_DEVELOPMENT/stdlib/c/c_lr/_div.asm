
XLIB _div

LIB asm__div

_div:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm__div
