
XLIB memcmp

LIB asm_memcmp

memcmp:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_memcmp
