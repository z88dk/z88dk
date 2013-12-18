
XLIB _ldiv

LIB asm__ldiv

_ldiv:

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   exx
   push de
   push hl
   push af
   
   exx
   jp asm__ldiv
