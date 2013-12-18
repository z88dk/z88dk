
XLIB memccpy

LIB asm_memccpy

memccpy:

   pop ix
   pop bc
   pop de
   ld a,e
   pop hl
   pop de
   
   push de
   push hl
   push de
   push bc
   push ix
   
   jp asm_memccpy
