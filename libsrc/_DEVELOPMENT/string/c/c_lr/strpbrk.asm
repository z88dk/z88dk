
XLIB strpbrk

LIB asm_strpbrk

strpbrk:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strpbrk
