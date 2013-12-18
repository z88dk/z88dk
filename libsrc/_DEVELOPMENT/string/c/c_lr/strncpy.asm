
XLIB strncpy

LIB asm_strncpy

strncpy:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strncpy
