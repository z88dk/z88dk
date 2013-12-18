
XLIB memrchr

LIB asm_memrchr

memrchr:

   pop de
   pop bc
   pop hl
   ld a,l
   pop hl
   
   push hl
   push hl
   push bc
   push de
   
   jp asm_memrchr
