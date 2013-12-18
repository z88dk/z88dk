
XLIB strncmp

LIB asm_strncmp

strncmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strncmp
