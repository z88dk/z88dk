
XLIB utoa

LIB asm_utoa

utoa:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_utoa
