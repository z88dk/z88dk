
XLIB strtoul

LIB asm_strtoul

strtoul:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_strtoul
