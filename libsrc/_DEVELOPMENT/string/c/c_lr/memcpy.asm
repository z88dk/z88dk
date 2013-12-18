
XLIB memcpy

LIB asm_memcpy

memcpy:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_memcpy
