
XLIB memswap

LIB asm_memswap

memswap:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_memswap
