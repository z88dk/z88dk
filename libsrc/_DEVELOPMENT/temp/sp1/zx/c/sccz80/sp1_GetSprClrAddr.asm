; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)

PUBLIC sp1_GetSprClrAddr

EXTERN asm_sp1_GetSprClrAddr

sp1_GetSprClrAddr:

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_sp1_GetSprClrAddr
