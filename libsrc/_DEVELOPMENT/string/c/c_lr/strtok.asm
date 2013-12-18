
XLIB strtok

LIB asm_strtok

strtok:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strtok
