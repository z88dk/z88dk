
XLIB memchr

LIB asm_memchr

memchr:

   pop de
   pop bc
   pop hl
   ld a,l
   pop hl
   
   push hl
   push hl
   push bc
   push de
   
   jp asm_memchr
