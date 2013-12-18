
XLIB strcoll

LIB asm_strcoll

strcoll:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strcoll
