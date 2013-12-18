
XLIB strnlen

LIB asm_strnlen

strnlen:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strnlen
