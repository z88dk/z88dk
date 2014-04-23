; void sp1_GetSprClr(uchar **sprsrc, struct sp1_ap *dest, uchar n)

XLIB sp1_GetSprClr

LIB asm_sp1_GetSprClr

sp1_GetSprClr:

   pop af
   pop bc
   ld b,c
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp asm_sp1_GetSprClr
