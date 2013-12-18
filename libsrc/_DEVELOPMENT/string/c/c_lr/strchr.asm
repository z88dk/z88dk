
XLIB strchr

LIB asm_strchr

strchr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strchr
