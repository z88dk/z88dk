
XLIB ba_bestfit

LIB asm_ba_bestfit

ba_bestfit:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld a,c
   jp asm_ba_bestfit
