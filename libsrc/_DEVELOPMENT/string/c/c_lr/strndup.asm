
XLIB strndup

LIB asm_strndup

strndup:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strndup
