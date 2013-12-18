
XLIB ba_addmem

LIB asm_ba_addmem

ba_addmem:

   pop af
   pop hl
   pop de
   pop bc
   pop ix
   
   push ix
   push bc
   push de
   push hl
   push af
   
   ld a,ixl
   jp asm_ba_addmem
