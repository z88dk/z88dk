; void sp1_GetSprClr(uchar **sprsrc, struct sp1_ap *dest, uchar n)
; CALLER linkage for function pointers

XLIB sp1_GetSprClr

LIB sp1_GetSprClr_callee
XREF ASMDISP_SP1_GETSPRCLR_CALLEE

.sp1_GetSprClr

   pop af
   pop bc
   ld b,c
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   jp sp1_GetSprClr_callee + ASMDISP_SP1_GETSPRCLR_CALLEE
