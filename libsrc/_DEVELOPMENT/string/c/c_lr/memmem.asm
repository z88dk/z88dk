
XLIB memmem

LIB asm_memmem

memmem:

   pop af
   pop bc
   pop de
   pop hl
   pop ix
   
   push ix
   push hl
   push de
   push bc
   push af
   
   jp asm_memmem
