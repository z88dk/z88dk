; void __CALLEE__ sp1_PutSprClr_callee(uchar **sprdest, struct sp1_ap *src, uchar n)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XDEF sp1_PutSprClr_callee

sp1_PutSprClr_callee:

   pop hl
   pop bc
   ld b,c
   pop de
   ex (sp),hl

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_PutSprClr.asm"
