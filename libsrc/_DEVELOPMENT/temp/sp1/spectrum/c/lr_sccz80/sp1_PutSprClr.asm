; void sp1_PutSprClr(uchar **sprdest, struct sp1_ap *src, uchar n)
; CALLER linkage for function pointers

XLIB sp1_PutSprClr

LIB asm_sp1_PutSprClr

sp1_PutSprClr:

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   ld b,c
   
   jp asm_sp1_PutSprClr
