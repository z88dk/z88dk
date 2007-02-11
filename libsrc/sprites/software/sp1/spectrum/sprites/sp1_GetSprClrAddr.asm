; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)
; CALLER linkage for function pointers

XLIB sp1_GetSprClrAddr

LIB sp1_GetSprClrAddr_callee
XREF ASMDISP_SP1_GETSPRCLRADDR_CALLEE

.sp1_GetSprClrAddr

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   jp sp1_GetSprClrAddr_callee + ASMDISP_SP1_GETSPRCLRADDR_CALLEE
   
