
XLIB strtol

LIB asm_strtol

strtol:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_strtol
