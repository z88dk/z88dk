
XLIB strsep

LIB asm_strsep

strsep:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   jp asm_strsep
