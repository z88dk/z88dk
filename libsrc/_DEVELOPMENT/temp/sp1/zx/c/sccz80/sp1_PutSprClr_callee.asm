; void __CALLEE__ sp1_PutSprClr_callee(uchar **sprdest, struct sp1_ap *src, uchar n)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION seg_code_sp1

PUBLIC sp1_PutSprClr_callee

sp1_PutSprClr_callee:

   pop hl
   pop bc
   ld b,c
   pop de
   ex (sp),hl

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_PutSprClr.asm"
