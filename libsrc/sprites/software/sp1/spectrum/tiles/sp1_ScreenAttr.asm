; uchar sp1_ScreenAttr(uchar row, uchar col)
; CALLER linkage for function pointers

PUBLIC sp1_ScreenAttr

EXTERN sp1_ScreenAttr_callee
EXTERN ASMDISP_SP1_SCREENATTR_CALLEE

.sp1_ScreenAttr

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp sp1_ScreenAttr_callee + ASMDISP_SP1_SCREENATTR_CALLEE
