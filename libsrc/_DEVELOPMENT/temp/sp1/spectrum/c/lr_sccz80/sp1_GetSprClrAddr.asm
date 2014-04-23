; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)

XLIB sp1_GetSprClrAddr

LIB asm_sp1_GetSprClrAddr

sp1_GetSprClrAddr:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_sp1_GetSprClrAddr
