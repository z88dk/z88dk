
XLIB strspn

LIB asm_strspn

strspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strspn
