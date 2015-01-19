; uint sp1_ScreenStr(uchar row, uchar col)
; CALLER linkage for function pointers

PUBLIC sp1_ScreenStr

EXTERN sp1_ScreenStr_callee
EXTERN ASMDISP_SP1_SCREENSTR_CALLEE

.sp1_ScreenStr

   ld hl,2
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp sp1_ScreenStr_callee + ASMDISP_SP1_SCREENSTR_CALLEE
