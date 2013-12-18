
XLIB strnchr

LIB asm_strnchr

strnchr:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_strnchr
